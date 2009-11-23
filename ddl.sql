DROP INDEX name_idx; DROP INDEX permalink_idx;;
alter table comments drop constraint FKDC17DDF4737D2A0B;
alter table posts_categories drop constraint FK32E78E08D85CD4CB;
alter table posts_categories drop constraint FK32E78E08737D2A0B;
alter table posts_tags drop constraint FK95F5DD05737D2A0B;
alter table posts_tags drop constraint FK95F5DD05E077C909;
drop table categories;
drop table comments;
drop table posts;
drop table posts_categories;
drop table posts_tags;
drop table statics;
drop table tags;
drop table users;
create table categories (id  bigserial not null, version int8 not null, name varchar(32) not null unique, primary key (id));
create table comments (id  bigserial not null, version int8 not null, guid varchar(255), body text not null, post_id int8 not null, email varchar(255), name varchar(255), last_updated timestamp not null, date_created timestamp not null, url varchar(255), primary key (id));
create table posts (id  bigserial not null, version int8 not null, body text not null, last_updated timestamp not null, guid varchar(64), author varchar(128), title varchar(255) not null, permalink varchar(255), comments_closed bool, allow_comments bool, date_created timestamp not null, primary key (id));
create table posts_categories (post_id int8 not null, category_id int8 not null, primary key (post_id, category_id));
create table posts_tags (post_id int8 not null, tag_id int8 not null, primary key (post_id, tag_id));
create table statics (id  bigserial not null, version int8 not null, body text not null, title varchar(255) not null, pos int4, primary key (id));
create table tags (id  bigserial not null, version int8 not null, name varchar(255) not null unique, primary key (id));
create table users (id  bigserial not null, version int8 not null, crypted_password varchar(64) not null, admin bool, name varchar(20) not null, date_created timestamp not null, salt varchar(64) not null, primary key (id));
alter table comments add constraint FKDC17DDF4737D2A0B foreign key (post_id) references posts;
alter table posts_categories add constraint FK32E78E08D85CD4CB foreign key (category_id) references categories;
alter table posts_categories add constraint FK32E78E08737D2A0B foreign key (post_id) references posts;
alter table posts_tags add constraint FK95F5DD05737D2A0B foreign key (post_id) references posts;
alter table posts_tags add constraint FK95F5DD05E077C909 foreign key (tag_id) references tags;
CREATE UNIQUE INDEX permalink_idx ON posts (permalink); CREATE UNIQUE INDEX name_idx ON users ( lower(name) ); ALTER TABLE posts ALTER COLUMN permalink SET NOT NULL; ALTER TABLE posts ALTER COLUMN guid SET NOT NULL;;
