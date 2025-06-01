-- creating the trademark database

if not exists (
    select * from sys.databases 
        where name = 'trademark'
)
create database trademark;
go

use trademark;
go

-- dropping foreign key constraints if they exist

if exists (
    select * from information_schema.table_constraints 
        where constraint_name='fk_legaldocuments_trademarks'
)
alter table legaldocuments drop constraint fk_legaldocuments_trademarks;

if exists (
    select * from information_schema.table_constraints 
        where constraint_name='fk_legaldocuments_organizations'
)
alter table legaldocuments drop constraint fk_legaldocuments_organizations;

if exists (
    select * from information_schema.table_constraints 
        where constraint_name='fk_categories_organizations'
)
alter table categories drop constraint fk_categories_organizations;

if exists (
    select * from information_schema.table_constraints 
        where constraint_name='fk_users_organizations'
)
alter table users drop constraint fk_users_organizations;

if exists (
    select * from information_schema.table_constraints 
        where constraint_name='fk_trademarks_organizations'
)
alter table trademarks drop constraint fk_trademarks_organizations;

if exists (
    select * from information_schema.table_constraints 
        where constraint_name='fk_organization_categories_organizations'
)
alter table organization_categories drop constraint fk_organization_categories_organizations;

if exists (
    select * from information_schema.table_constraints 
        where constraint_name='fk_organization_categories_categories'
)
alter table organization_categories drop constraint fk_organization_categories_categories;

-- dropping the tables if they exist

drop table if exists organization_categories;
drop table if exists legaldocuments;
drop table if exists trademarks;
drop table if exists categories;
drop table if exists users;
drop table if exists organizations;
go

-- creating the tables

-- creating the organizations table

create table organizations (
    organization_key bigint identity(1,1) not null,
    ein varchar(20) not null,
    organization_name varchar(50) not null,
    email varchar(50) not null,
    website varchar(255) not null,
    constraint pk_organizations primary key (organization_key),
    constraint u_organizations unique (website),
    constraint u_ein unique (ein)
);

-- creating the trademarks table

create table trademarks (
    trademark_key int identity(1,1) not null,
    trademark varchar(255) not null,
    registration date not null,
    expiry date not null,
    organization_key bigint not null,
    constraint pk_trademarks primary key (trademark_key),
    constraint fk_trademarks_organizations foreign key(organization_key) references organizations(organization_key),
    constraint u_trademarks unique (trademark)
);

-- creating the legaldocuments table

create table legaldocuments (
    legaldocument_key int identity(1,1) not null,
    trademark_key int not null,
    issue date not null,
    expiry date not null,
    case_number varchar(50),
    organization_key bigint not null,
    constraint pk_legaldocuments primary key (legaldocument_key),
    constraint fk_legaldocuments_organizations foreign key (organization_key) references organizations(organization_key),
    constraint fk_legaldocuments_trademarks foreign key (trademark_key) references trademarks(trademark_key),
    constraint u_legaldocuments unique (case_number)
);

-- creating the categories table

create table categories (
    category_key int identity(1,1) not null,
    category_name varchar(50) not null,
    description varchar(255),
    organization_key bigint not null,
    constraint pk_categories primary key (category_key),
    constraint fk_categories_organizations foreign key (organization_key) references organizations(organization_key),
    constraint u_categories unique (category_name)
);

-- creating the users table

create table users (
    user_key int identity(1,1) not null,
    user_name varchar(50) not null,
    password varchar(50) not null,
    email_address varchar(255) not null,
    organization_key bigint not null,
    constraint pk_users primary key (user_key),
    constraint fk_users_organizations foreign key (organization_key) references organizations(organization_key),
    constraint u_users1 unique (user_name),
    constraint u_users2 unique (email_address)
);

-- creating the organizations_categories bridge table 

create table organization_categories (
    organization_category_key int identity(1,1) not null,
    organization_key bigint not null,
    category_key int not null,
    constraint pk_organization_categories primary key (organization_category_key),
    constraint fk_organization_categories_organizations foreign key (organization_key) references organizations(organization_key),
    constraint fk_organization_categories_categories foreign key (category_key) references categories(category_key),
    unique (organization_key, category_key)
);
go

-- inserting data into organizations table

insert into organizations (ein, organization_name, email, website)
    values
        (1000000001, 'Organization 1', 'email1@org.com', 'www.org1.com'),
        (1000000002, 'Organization 2', 'email2@org.com', 'www.org2.com'),
        (1000000003, 'Organization 3', 'email3@org.com', 'www.org3.com'),
        (1000000004, 'Organization 4', 'email4@org.com', 'www.org4.com'),
        (1000000005, 'Organization 5', 'email5@org.com', 'www.org5.com'),
        (1000000006, 'Organization 6', 'email6@org.com', 'www.org6.com'),
        (1000000007, 'Organization 7', 'email7@org.com', 'www.org7.com'),
        (1000000008, 'Organization 8', 'email8@org.com', 'www.org8.com'),
        (1000000009, 'Organization 9', 'email9@org.com', 'www.org9.com'),
        (1000000010, 'Organization 10', 'email10@org.com', 'www.org10.com');
go

-- inserting data into trademarks table

insert into trademarks (trademark, registration, expiry, organization_key) 
    values
        ('Trademark A', '2023-01-01', '2033-01-01', 1),
        ('Trademark B', '2023-02-01', '2033-02-01', 2),
        ('Trademark C', '2023-03-01', '2033-03-01', 3),
        ('Trademark D', '2023-04-01', '2033-04-01', 4),
        ('Trademark E', '2023-05-01', '2033-05-01', 5),
        ('Trademark F', '2023-06-01', '2033-06-01', 6),
        ('Trademark G', '2023-07-01', '2033-07-01', 7),
        ('Trademark H', '2023-08-01', '2033-08-01', 8),
        ('Trademark I', '2023-09-01', '2033-09-01', 9),
        ('Trademark J', '2023-10-01', '2033-10-01', 10);
go

-- inserting data into legaldocuments table

insert into legaldocuments (trademark_key, issue, expiry, case_number, organization_key) 
    values
        (1, '2023-01-15', '2033-01-15', 'Case001', 1),
        (2, '2023-02-15', '2033-02-15', 'Case002', 2),
        (3, '2023-03-15', '2033-03-15', 'Case003', 3),
        (4, '2023-04-15', '2033-04-15', 'Case004', 4),
        (5, '2023-05-15', '2033-05-15', 'Case005', 5),
        (6, '2023-06-15', '2033-06-15', 'Case006', 6),
        (7, '2023-07-15', '2033-07-15', 'Case007', 7),
        (8, '2023-08-15', '2033-08-15', 'Case008', 8),
        (9, '2023-09-15', '2033-09-15', 'Case009', 9),
        (10, '2023-10-15', '2033-10-15', 'Case010', 10);
go

-- inserting data into categories table

insert into categories (category_name, description, organization_key) 
    values
        ('Category 1', 'Description 1', 1),
        ('Category 2', 'Description 2', 2),
        ('Category 3', 'Description 3', 3),
        ('Category 4', 'Description 4', 4),
        ('Category 5', 'Description 5', 5),
        ('Category 6', 'Description 6', 6),
        ('Category 7', 'Description 7', 7),
        ('Category 8', 'Description 8', 8),
        ('Category 9', 'Description 9', 9),
        ('Category 10', 'Description 10', 10);
go

-- inserting data into users table

insert into users (user_name, password, email_address, organization_key) 
    values
        ('User1', 'Pass1', 'user1@org1.com', 1),
        ('User2', 'Pass2', 'user2@org2.com', 2),
        ('User3', 'Pass3', 'user3@org3.com', 3),
        ('User4', 'Pass4', 'user4@org4.com', 4),
        ('User5', 'Pass5', 'user5@org5.com', 5),
        ('User6', 'Pass6', 'user6@org6.com', 6),
        ('User7', 'Pass7', 'user7@org7.com', 7),
        ('User8', 'Pass8', 'user8@org8.com', 8),
        ('User9', 'Pass9', 'user9@org9.com', 9),
        ('User10', 'Pass10', 'user10@org10.com', 10);
go

-- inserting data into organization_categories table

insert into organization_categories (organization_key, category_key) 
    values
        (1, 1),
        (2, 2),
        (3, 3),
        (4, 4),
        (5, 5),
        (6, 6),
        (7, 7),
        (8, 8),
        (9, 9),
        (10, 10);
go

-- displaying the data

select * from dbo.organizations;
select * from dbo.trademarks;
select * from dbo.legaldocuments;
select * from dbo.categories;
select * from dbo.users;
select * from dbo.organization_categories

-- creating the stored procedures

-- stored procedure for creation

-- dropping addorganization if it already exists

if exists (
    select *
        from sys.objects 
    where 
        type = 'p' and name = 'addorganization'
)
drop procedure addorganization;
go

create procedure addorganization
    @ein varchar(20),
    @organization_name varchar(50),
    @email varchar(50),
    @website varchar(255)
as
begin
    insert into organizations (ein, organization_name, email, website)
    values (@ein, @organization_name, @email, @website)
end
go

-- stored procedure for reading

-- dropping readorganization if it already exists

if exists (
    select * 
        from sys.objects 
    where 
        type = 'p' and name = 'readorganization'
)
drop procedure readorganization;
go

create procedure readorganization
    @organization_key bigint
as
begin
    select * from organizations
    where organization_key = @organization_key
end
go

-- stored procedure for updating

-- dropping updateorganization if it already exists

if exists (
    select * 
        from sys.objects 
    where 
        type = 'p' and name = 'updateorganization'
)
drop procedure updateorganization;
go

create procedure updateorganization
    @organization_key bigint,
    @ein varchar(20) = null,
    @organization_name varchar(50) = null,
    @email varchar(50) = null,
    @website varchar(255) = null
as
begin
    update organizations
    set ein = coalesce(@ein, ein),
        organization_name = coalesce(@organization_name, organization_name),
        email = coalesce(@email, email),
        website = coalesce(@website, website)
    where organization_key = @organization_key
end
go

-- stored procedure for deleting

-- dropping deleteorganization if it already exists

if exists (
    select * 
        from sys.objects 
    where 
        type = 'p' and name = 'deleteorganization'
)
drop procedure deleteorganization;
go

create procedure deleteorganization
    @organization_key bigint
as
begin
    delete from organizations
    where organization_key = @organization_key
end
go

-- executing the stored procedures

-- executing the stored procedure for creating

exec addorganization 
    @ein = '999999999', 
    @organization_name = 'new organization', 
    @email = 'contact@neworg.com', 
    @website = 'www.neworg.com';

-- executing the stored procedure for reading

exec readorganization 
    @organization_key = 11;

-- executing the stored procedure for updating 

exec updateorganization 
    @organization_key = 11,
    @ein = '999999998',
    @organization_name = 'updated organization', 
    @email = 'updated@neworg.com', 
    @website = 'www.updatedorg.com';

-- executing the stored procedure for deleting

exec deleteorganization 
    @organization_key = 11;

-- view to display the data

if exists (select * from sys.views where object_id = object_id('vw_comprehensive_overview'))
    drop view vw_comprehensive_overview;
go

create view vw_comprehensive_overview as
select
    o.organization_name,
    o.email,
    o.website,
    t.trademark,
    t.registration,
    t.expiry as trademark_expiry,
    ld.issue,
    ld.expiry as legaldocument_expiry,
    ld.case_number,
    c.category_name,
    c.description,
    u.user_name,
    u.email_address
from organizations o
join trademarks t on o.organization_key = t.organization_key
join legaldocuments ld on t.trademark_key = ld.trademark_key
join categories c on o.organization_key = c.organization_key
join users u on o.organization_key = u.organization_key
join organization_categories oc on o.organization_key = oc.organization_key and c.category_key = oc.category_key
go

-- displaying the view

select * from vw_comprehensive_overview