<%--
  Created by IntelliJ IDEA.
  User: morris
  Date: Nov 14, 2009
  Time: 5:17:18 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
    <title>Simple GSP page</title>
    <meta name="layout" content="blog" />
  </head>
  <body>
         <div class='post'>
           <h2><a href="/articles/2009/11/11/using-postgresql-with-grails">Using Postgresql with Grails</a></h2>
           <p class='auth'>
             Posted by Jim Morris
             <span class='typo_date'>on Wed Nov 11 13:59:07 -0800 2009</span>

           </p>
           <p>I started playing with Grails, and I am planning to rewrite the blog
           engine I use for this blog in Grails. As noted
           <a href="http://blog.wolfman.com/articles/2009/1/13/new-merb-based-blog">earlier</a>
           I wrote it in Merb originally. Although Merb is nice and lite it seems
           to be having difficulty keeping up with the gems it is dependent on. A
           case in point is Cucumber which it says is its recommended way of
           doing integration tests. The current version of Cucumber is very
           difficult to get working with Merb. See the
           <a href="http://github.com/wolfmanjm/wolfmanblog">Git source</a> to see how I
           finally did it.</p>

           <p>While I was learning Grails, I hooked up Postgresql 8.2 to Grails
           using the <code>Datasource.groovy</code> file. I turned on SQL logging, and to my
           horror saw how it was handling the id's. I have been using Postgresql
           for quite a while now, and used to run into problems with the creation
           and retrieval of the automatically generated IDs. It seems a lot of
           people run into these hard to describe problems, as it appears to
           happen rarely and is probably a race condition. With version >= 8.2
           Postgresql introduced a way of inserting a new record and returning
           the automatically generated id in one atomic statement. This solves
           all the problems and is more efficient as it does not require two
           queries for each insert.</p>


           <pre><code>insert into users (version, crypted_password, admin, name, date_created, salt)&#x000A;values (?, ?, ?, ?, ?, ?) RETURNING id&#x000A;</code></pre>

           <p>For id when it has this schema</p>

           <pre><code>id | bigint | not null default nextval('users_id_seq'::regclass)&#x000A;</code></pre>

           <p>The <code>RETURNING id</code> is the trick here.</p>

           <p>By default Hibernate, which is the underlying ORM used by GORM, which
           is the Grails ORM, seems to use a sequence to generate the next id
           then write the id in the INSERT SQL statement.</p>


           <pre><code>select nextval ('hibernate_sequence')&#x000A;&#x000A;insert into users (version, crypted_password, admin, name, date_created, salt, id)&#x000A;values (?, ?, ?, ?, ?, ?, ?)&#x000A;</code></pre>

           <p>This sequence should work in most cases, as <code>nextval</code> is supposed to
           be atomic and should return a unique sequence regardless of how many
           threads are concurrently accessing the database, however I have
           <a href="https://forum.hibernate.org/viewtopic.php?p=2385225">read</a> that this
           causes problems in Hibernate and in Grails a
           <a href="http://jira.codehaus.org/browse/GRAILS-2662">bug</a> was filed saying
           that this causes problems in Grails if you are doing inserts during
           the bootstrap process, something to do with the way Hibernate caches
           or batches stuff.</p>


           <p>If you force hibernate to use the identity method of sequences
           <code>id generator:'identity'</code> which is the preferred method anyway, then
           Hibernate uses this sequence to get the id after an insert...</p>

           <pre><code>insert into users (version, crypted_password, admin, name, date_created, salt)&#x000A;values (?, ?, ?, ?, ?, ?)&#x000A;&#x000A;select currval('users_id_seq')&#x000A;</code></pre>

           <p>Now I know that this sequence (other than being inefficient) can be
           subject to a race condition where the id returned is not the id that
           was just generated. I do not know why as Postgresql says it should
           work, but I have actually been bitten by that on occasion in
           production, and it was solved by using <code>RETURNING id</code>.</p>

           <p>So I was surprised that the current version of Hibernate does not use
           the currently recommended way of doing this common sequence. However
           it does provide a way to work around the problem. This solution really
           only works in Grails, because you have to hard code the column used
           for the id, if the API in Hibernate was a little more flexible it
           could be made generic, but that is an issue for the Hibernate JIRA.</p>


           <p>Anyway here is the solution for Grails.</p>

           <p>First stick this file in
           <code>GRAILS_PROJECT/src/java/com/e4net/hibernate/dialect/PostgreSQL82Dialect.java</code></p>

           <pre><code>package com.e4net.hibernate.dialect;&#x000A;&#x000A;import org.hibernate.dialect.PostgreSQLDialect;&#x000A;&#x000A;public class PostgreSQL82Dialect extends PostgreSQLDialect {&#x000A;&#x000A;    public PostgreSQL82Dialect() {&#x000A;&#x000A;    }&#x000A;&#x000A;    public boolean supportsInsertSelectIdentity() {&#x000A;            return true;&#x000A;    }&#x000A;&#x000A;    public String appendIdentitySelectToInsert(String insertString) {&#x000A;            return insertString + " RETURNING id";&#x000A;    }&#x000A;}&#x000A;</code></pre>


           <p>This sets up a extension to the standard Postgresql dialect that
           Hibernate uses. It tells Hibernate that the id can be returned in the
           same SQL statement of the INSERT, and also how to modify the insert
           SQL statement to do that. This is where <code>id</code> is hard coded, if we were
           passed a little more information like what the identity column was we
           could make this generic.</p>

           <p>Then in your <code>GRAILS_PROJECT/grails-app/conf/DataSource.groovy</code></p>

           <pre><code>            dataSource {&#x000A;                    dbCreate = "update" // one of 'create', 'create-drop','update'&#x000A;                    url = "jdbc:postgresql://localhost/wolfmanblog_dev"&#x000A;                    driverClassName = "org.postgresql.Driver"&#x000A;                    dialect = 'com.e4net.hibernate.dialect.PostgreSQL82Dialect'&#x000A;                    logSql = true&#x000A;                    username = "xxxx"&#x000A;                    password = "xxxx"&#x000A;            }&#x000A;</code></pre>


           <p>Note the <code>dialect = 'com.e4net.hibernate.dialect.PostgreSQL82Dialect'</code>
           this tells it to use the class we created above.</p>

           <p>Now we need to tell Hibernate to always use the <code>identity</code> method for
           generating ids. This can be done in the static mapping stanza in each
           of your domain classes...</p>

           <pre><code>static mapping = {&#x000A;    id generator: 'identity'&#x000A;}&#x000A;</code></pre>


           <p>Or if you are using Grails 1.2-M4 or better you can put this in
           <code>GRAILS_PROJECT/grails-app/conf/Config.groovy</code></p>

           <pre><code>grails.gorm.default.mapping = {&#x000A;    id generator:'identity'&#x000A;}&#x000A;</code></pre>

           <p>Which will change the default for all your domain classes.</p>

           <p>Now when you do an insert you will get this...</p>

           <pre><code>insert into users (version, crypted_password, admin, name, date_created, salt)&#x000A;values (?, ?, ?, ?, ?, ?) RETURNING id&#x000A;</code></pre>


           <p>Which is more efficient and correct.</p>

           <p>I'd like to see this in the default Hibernate Postgresql
           dialect, maybe it could determine the version of Postgresql it is
           using and do the correct thing?</p>

           <p><a href="http://technorati.com/tag/hibernate+postgresql" rel="tag"></a>
           <a href="http://technorati.com/tag/grails+postgresql" rel="tag"></a></p>
           <p class='meta'>
             Posted in
             <a href="/articles/category/Grails">Grails</a>
             <strong>&nbsp;|&nbsp;</strong>

             Tags
             <a href="/articles/tag/grails">grails</a>,<a href="/articles/tag/hibernate">hibernate</a>,<a href="/articles/tag/postgresql">postgresql</a>
             <strong>&nbsp;|&nbsp;</strong>
             <a href="/posts/50#comments">1 comments</a>
           </p>
           <a href="/articles/2009/11/11/using-postgresql-with-grails">Show</a>

         </div>
         <div class='post'>
           <h2><a href="/articles/2009/10/24/converting-a-sidewinder-3d-pro-joystick-to-usb">Converting a Sidewinder 3D pro joystick to USB</a></h2>
           <p class='auth'>
             Posted by Jim Morris
             <span class='typo_date'>on Sat Oct 24 14:50:02 -0700 2009</span>
           </p>
           <p>In playing with my new Rovio I decided that my Old MS Sidewinder 3D
           Pro Joystick would be an excellent way to control it, as it has the
           twist which can rotate the Rovio, and the joystick up/left/down/right
           can move the Rovio in those directions while still facing forward.</p>


           <p>The problem is that the joystick has a game port connector, and my
           Linux workstation does not have a game-port. After doing the obligatory
           Googling I found
           <a href="http://www.descentbb.net/viewtopic.php?t=15526">this</a> Exactly what I
           needed, except this was for Windows not Linux. Thinking I would have
           to modify the code I contacted Grendel who graciously sent me the
           source code for the project, however it turns out the code he wrote
           was so good it works as is on Linux, I just needed to <code>modprobe
           sidewinder</code> and it worked.</p>

           <p>The project is based on a great little hackers device called a
           <a href="http://www.pjrc.com/store/teensy.html">Teensy</a> a relatively cheap
           general purpose programmable USB dev board. It has lots of
           sample code showing it being a keyboard or mouse or serial port
           etc. It is programmed in C using the avr-gcc toolchain. This is like a
           Basic Stamp with USB, something I needed years ago but couldn't
           find. Now I have one I forgot what I needed it for many years ago, but
           it is in my arsenal now.</p>

           <p>The only thing I needed to do, as I was on Ubuntu Hardy (8.04 LTS) and
           not 8.10 or newer, was to build the avr-gcc toolchain myself. The one
           included with Hardy did not recognize the atmel mmcu atmega32u4 type,
           which is relatively new. This process is made much easier with a
           script you can get from this
           <a href="http://www.avrfreaks.net/index.php?name=PNphpBB2&amp;file=viewtopic&amp;t=42631">thread</a>,
           Note you need to register with the forum to see the download
           links. The file you want is
           <code>build-avr-gcc-4.3.3-libc-1.6.7-insight6.8-arch25-fix.zip</code>. Make sure you
           read the first post of the thread and make sure you have all the
           dependencies installed first according to the pre-reqs.txt file in the
           download. (Especially the libmpfr-dev which I missed initially).</p>


           <p>Anyway I prototyped the circuit using the photos provided in Grendels
           post, and plugged it into a Windows XP system and it worked, then I
           plugged it into my Linux box and dmesg told me it recognized the
           joystick device..  </p>

           <pre><code>[926661.299475] input,hidraw8: USB HID v1.11 Joystick [Detlef &lt;Grendel&gt; Mueller Microsoft SideWinder 3D Pro (USB)] on usb-0000:00:1d.7-4.3&#x000A;</code></pre>

           <p>I then downloaded jstest which is a simple joystick test program, and
           all the degrees of freedom were recognized.</p>

           <p>I wanted to make the proto more robust so I designed a PCB layout
           using
           <a href="http://www.expresspcb.com/ExpressPCBHtm/Download.htm">ExpressPCB's</a>
           free PCB design and schematic tool (Windows based but runs fine under
           Wine on Linux). These guys will make 3 off 3.8" x 2.5" PCBs
           <a href="http://www.expresspcb.com/ExpressPCBHtm/Specs.htm">MiniBoard</a> for
           around $50, which is a get price if you can't make your own. However I
           decided that for this one off project I'd just do a PCB prototype
           instead, so I sent the PCB layout to Grendel as thanks for all his
           hard work, in case he ever wants to go into production for this great
           little project.</p>


           <p>I got a
           <a href="http://www.schmartboard.com/index.asp?page=products_th&amp;id=24">Schmartboard</a>
           board (around $5 from Fry's) and a Rt Angle female pcb mount 15 pin
           DSub connector (.99c), and soldered the components and jumper
           wires. The DSUB needed coaxing onto the board as I guess the pin
           spacing is not the standard 0.01", however Shmartboard does have a
           <a href="http://www.schmartboard.com/index.asp?page=products_io&amp;id=16">board</a>
           especially for dsub connectors, Fry's did not stock it though. I like
           these Schmartboards, they are cheap and well built, through hole, and
           you can even do surface mount if you have to. They are a lot better
           quality than what you can get from Radio shack!</p>

           <p><img src="/files/IMG_0332.JPG" alt="3DPVert"/>
           <img src="/files/IMG_0333.JPG" alt="3DPVert"/></p>

           <p>As a side note, as I am getting older and it has been 10 years since I
           did any pcb soldering I found that my eyesight has deteriorated to the
           point that I needed a magnifying lamp to do this work, and that my hand
           is no longer as steady as it was, and that my old trusty Weller 35W
           pro soldering iron was too hot and unwieldy, and I was making solder
           bridges everywhere and melting the wire and connectors. (That did not
           used to happen when I was younger ;) So I splashed out and got a nice
           new
           <a href="http://www.hakkousa.com/detail.asp?PID=1250&amp;Page=1">Hakko 936 soldering station</a>,
           with the 907 iron and a very fine soldering
           <a href="http://www.hakkousa.com/detail.asp?PID=1141&amp;Page=1">tip</a> and some
           very fine solder. This made this go a lot smoother, although finding
           the right temperature to use was hit and miss.</p>


           <p>The last component was putting the finished product into a box. None
           of the Radioshack boxes I had lying around would fit, so remembering
           that I had great fun building an Acrylic box for my PC (which I
           eventually ditched for a Silenced case), I made a little acrylic box
           for the converter. A trip to Tap Plastics to get the adhesive was all
           that was needed as I still had some Acrylic scraps laying around.</p>

           <p>Anyway that was my project for this week. Next up writing the code to
           control the Rovio with my Sidewinder 3D Pro. What Language to use??
           Ruby, C++/Qt, Java, maybe learn a new one like Groovy? Hmmm what a
           Dilemma.</p>
           <p class='meta'>
             Posted in
             <a href="/articles/category/Linux">Linux</a>,<a href="/articles/category/Embedded">Embedded</a>,<a href="/articles/category/Robotics">Robotics</a>
             <strong>&nbsp;|&nbsp;</strong>

             Tags
             <a href="/articles/tag/joystick">joystick</a>,<a href="/articles/tag/usb">usb</a>,<a href="/articles/tag/soldering">soldering</a>
             <strong>&nbsp;|&nbsp;</strong>
             no comments
           </p>
           <a href="/articles/2009/10/24/converting-a-sidewinder-3d-pro-joystick-to-usb">Show</a>

         </div>
         <div class='post'>
           <h2><a href="/articles/2009/10/21/fun-with-a-pc104-board-embedded-linux-and-wifi">Fun with a PC104 board, embedded Linux and wifi</a></h2>
           <p class='auth'>
             Posted by Jim Morris
             <span class='typo_date'>on Wed Oct 21 01:32:16 -0700 2009</span>
           </p>
           <p>Around 10 years ago I was playing with some home robotics, built a
             simple robot, with some sensors and an on-board Linux-based PC. The
             purpose was to experiment with Robot AI, a continuation of my PhD
             thesis I started on some 30 years ago, but did not complete.</p>


           <p>The robot had a camera, a digital compass, a sonar scanner and a short
             range IR range detector, plus some bump detectors. I could control
             it over a wifi connection, that was a Orinoco PCMCIA board plugged
             into the PC104, 586 based Linux PC that was on-board. All powered by
             several batteries.</p>

           <p>I ran out of time and interest and energy and shelved the project. 10
             Years later I stumbled upon a relatively cheap camera, wifi based
             robot called a
             <a href="http://www.wowwee.com/en/products/tech/telepresence/rovio/rovio">Rovio</a>
             made by Wowwee, its basically a toy, but a cool one. The Rovio has
             much better manouverability than my feeble attempt, and it has a
             camera and is controlled over Wifi by some well documented HTTP
             calls.</p>

           <p>I bought one of these gizmos to play with, and to "use" as a remote
             security camera to check on the dogs when I am not home. It fired up
             my Robot hobby enthusiasm, and as I have a lot of time on my hands
             these days I dug out all my old stuff, which I had mostly forgotten,
             and dusted off the old PC104 embedded system and tried to get it up
             and running again. I'm not sure what I'll use it for but it was
             pretty expensive back in the day, so I'll find some use for
             it. Maybe I'll stick it on the Rovio to give it some more computing
             power.</p>

           <p>Anyway things have changed a lot since then, a PC104 is ISA based, and
             this board had no USB ports, but I did have a PCMCIA slot, which was
             5v 16 bit only. This posed a problem as all PCMCIA cards today are
             Cardbus 3.3v and usually 32 bit. The only wifi card I had that was
             5v was the old Lucent Orinoco 802.11b card. But my AP these days is
             a WPA/WPA2 based 802.11b/g.</p>

           <p>The first fun thing was to get wpa_supplicant running on this old
             thing, if possible. I mentioned no USB because one workaround was to
             use a newer wifi card, I also wanted to use some flash drives. But
             this turns out to be impossible as no ISA/PC104 USB cards were ever
             built (according to an extensive Google search).</p>


           <p>The board has 32Mb of RAM, and that was fully loaded, it also ran
             <a href="http://www.blast.com/index.php?id=35">WhiteDwarf Linux</a> out of a
             32Mb disk-on-a-chip board that plugs into the IDE socket. The old
             version of WDLINUX I had definitely would not run the newer Hermes
             Linux drivers and wpa_supplicant. I found that Whitedwarf is still
             in business and have a newer version of wdlinux2.2. This is a
             Slackware based Dist, that fits in under 32Mb of Ram and Disk. But I
             want to run Ruby on this thing, and probably Java, so I needed some
             more room which meant swap space, and swap and flash drives don't go
             well together, so I dug out a 4Gb Seagate Microdrive I bought at
             Frys a few years back, which would do really nicely. However getting
             it to work reliably turned out to be tricky. I grabbed the latest
             version of wdlinux, and did some digging to find it seems to be
             based on Slackware 8.1, which is important as you need more packages
             to make it useful than wdlinux has, so installing from Slackware
             makes things easier.  They have an ISO so I installed the ISO in a
             Vmware Workstation, so I could compile a new kernel and compile any
             application on my workstation, and then tried to install it also on
             the 4Gb microdrive. This worked eventually but it turns out the
             microdrive likes to go to sleep every few seconds, (I guess to save
             power when it is plugged into a camera or whatnot). This caused
             Linux to get upset (the kernel version is 2.4.29). I saw a lot of
             errors saying "no drq after write", this was caused by it going to
             sleep, as I found if I did </p>

           <pre><code>&gt; dd if=/dev/hda of=/dev/null`&#x000A;</code></pre>

           <p>in a separate terminal, it kept it awake. The long term workaround
             was to execute </p>

           <pre><code>&gt; hdparm -B255 /dev/hda&#x000A;</code></pre>


           <p>as soon as possible after boot, this turns off the power saving
             mode. I put it in <code>/etc/rc.d/rc.S</code> which is the first thing to get
             executed on startup. This error is more than annoying it corrupted
             the disk more than once.</p>

           <p>I ordered a compact flash to ide44 adapter and short 44pin f-f cable
             so I could plug the microdrive into the ide connector on the board.</p>

           <p>So now I had wdlinux 2.2 installed on a 4Gb microdrive on the PC104
              board. Luckily 2.2 came with PCMCIA and associated tools already
              built into the kernel, unfortunately the module for my particular
              PCMCIA adapter board was not built, so I built a new kernel with
              the relevant driver built as a module, and was able to get the
              PCMCIA system up, plugging in the Orinoco card loaded the
              <code>orinoco_cs</code> driver which would work fine if I was still using
              WEP. After much Googling I found that the Orinoco which is a
              Hermes-I based card, would apparently work with wpa_supplicant if
              you upgraded the firmware and used a Linux driver released by Agere
              (who have since been acquired and their web site dismantled)
              Luckily I found the source online somewhere (Google for
              <code>wl_lkm_718_release.tar.gz</code>), and built it. The driver is called
              wlags49 and comes in a Hermes-I and Hermes-II flavors and for
              pccarc and pci, also the firmware is downloaded and can be either
              station or ap modes. After browsing through the source code they
              provided (which BTW only works on 2.4.x kernels) I figured out how
              to build it properly and also build the version of <code>wpa_supplicant</code>

              and Hermes driver that came with it. (I saw that some people have
              provided patches to make the code compile under 2.6.x kernels, but
              that didn't help me too much).</p>

           <p>Initially the driver didn't seem to work too well, <code>iwlist eth1
            scanning</code> did not seem to return anything, and <code>wpa_supplicant</code> also
            barfed when it tried to scan for AP's. A bit more digging and reading
            the sparse docs, looked like I needed to do some configuration of the
            module when it was loaded, rather than allow wpa_supplicant to do all
            the configuration. They provide a way to configure the Agere based
            chips with a <code>/etc/agere/iwconfig-eth1</code> file. I set the SSID, the
            download_firmware and the debugging flags, and it seemed to fix
            everything. The <code>wpa_supplicant.conf</code> file was pretty sparse as it was
            a really old version of wpa_supplicant they were using, but it was
            enough to finally get a connection via WPA to my AP. Note WPA2 is not
            supported.</p>


           <p>Along the way I was looking for alternatives, like using a newer
             PCMCIA card, I had a 3.3v newer card, but that wouldn't plug in to
             the 5v adapter, and I couldn't find a 5v to 3.3 v adapter on the
             market, which is odd as it is one chip to do it. I also couldn't
             find many 5v wireless cards, although it looked like I could still
             buy a Linksys WPC11 card so long as it was v1, v2 or v3, the new
             ones are v4 and appear to be 3.3v only.</p>

           <p>So things learned...</p>

           <ul>
           <li>There are no USB boards for ISA (or PC104) based PCs</li>
           <li>New PCMCIA cards are 3.3v and won't work on older PCMCIA adapters
           (or Laptops)</li>
           <li>There are no converters that allow you to run a newer 3.3v PCMCIA
           card in a 5v slot</li>

           <li>Orinoco cards can be made to work with WPA, but require newer
           firmware and the Agere drivers.</li>
           <li>working with old H/W is a pain, but embedded boards such as PC104
           are still using old technology, although PC104+ does have a PCI bus
           which allows newer boards to be used</li>
           <li>Using a compact card microdrive to run Linux off of is possible but
           you need to disable the power management in the drive</li>
           </ul>

           <p>Now I finally have my old PC104 board running again with its wireless
            card and talking WPA, I have to figure out what to do with it :)</p>

           <p>My next project is to build a USB adapter for my old Microsoft
            Sidewinder 3D Pro joystick, so I can use it on Linux to control my
            Rovio. This has already been mostly
            <a href="http://www.descentbb.net/viewtopic.php?t=15526">done</a> but for
            Windows. I am going to modify it to talk a serial protocol so I can
            plug it into my Linux workstation.</p>


           <p><a href="http://technorati.com/tag/microdrive+linux" rel="tag"></a>
           <a href="http://technorati.com/tag/orinoco+wpa" rel="tag"></a>
           <a href="http://technorati.com/tag/whitedwarf+linux" rel="tag"></a></p>
           <p class='meta'>
             Posted in
             <a href="/articles/category/Linux">Linux</a>,<a href="/articles/category/Embedded">Embedded</a>
             <strong>&nbsp;|&nbsp;</strong>

             Tags
             <a href="/articles/tag/linux">linux</a>,<a href="/articles/tag/pc104">pc104</a>,<a href="/articles/tag/wpa_supplicant">wpa_supplicant</a>,<a href="/articles/tag/microdrive">microdrive</a>
             <strong>&nbsp;|&nbsp;</strong>
             no comments
           </p>
           <a href="/articles/2009/10/21/fun-with-a-pc104-board-embedded-linux-and-wifi">Show</a>

         </div>
 
</body>
</html>