/*
TAP Tests for view functions 

*/

BEGIN;

SELECT tap.plan(78);

-- setup for tests
DROP DATABASE IF EXISTS taptest;
CREATE DATABASE taptest;

-- This will be rolled back. :-)
DROP TABLE IF EXISTS `taptest`.`sometab`;
CREATE TABLE `taptest`.`sometab`(
    id      INT NOT NULL PRIMARY KEY,
    name    TEXT,
    numb    FLOAT(10, 2) DEFAULT NULL,
    myNum   INT(8) DEFAULT 24,
    myat    TIMESTAMP DEFAULT NOW(),
    plain   INT
) ENGINE=INNODB, CHARACTER SET utf8, COLLATE utf8_general_ci;

DROP VIEW IF EXISTS `taptest`.`someview`;
CREATE DEFINER = root@localhost SQL SECURITY INVOKER VIEW `taptest`.`someview` AS
SELECT id AS viewid, name AS viewname5 FROM taptest.sometab
WITH LOCAL CHECK OPTION; 


DROP VIEW IF EXISTS `taptest`.`definerview`;
CREATE SQL SECURITY DEFINER VIEW `taptest`.`definerview` AS
SELECT id AS viewid, name AS viewname FROM taptest.sometab; 


/****************************************************************************/
-- has_view(sname VARCHAR(64), vname VARCHAR(64), description TEXT)
SELECT tap.check_test(
    tap.has_view('taptest', 'someview', ''),
    true,
    'has_view() extant view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_view('taptest', 'nonexistent', ''),
    false,
    'has_view() nonexistent view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_view('taptest', 'someview', ''),
    true,
    'has_view() default description',
    'View taptest.someview should exist',
    null,
    0
);

SELECT tap.check_test(
    tap.has_view('taptest', 'someview', 'desc'),
    true,
    'has_view() description supplied',
    'desc',
    null,
    0
);


/****************************************************************************/
-- hasnt_view(sname VARCHAR(64), vname VARCHAR(64), description TEXT)

SELECT tap.check_test(
    tap.hasnt_view('taptest', 'nonexistent', ''),
    true,
    'hasnt_view() with nonexistent view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_view('taptest', 'someview', ''),
    false,
    'hasnt_view() with extant view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_view('taptest', 'nonexisting', ''),
    true,
    'hasnt_view() default description',
    'View taptest.nonexisting should not exist',
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_view('taptest', 'nonexisting', 'desc'),
    true,
    'hasnt_view() description supplied',
    'desc',
    null,
    0
);


/****************************************************************************/
-- has_security_invoker(sname VARCHAR(64), vname VARCHAR(64), description TEXT)


SELECT tap.check_test(
    tap.has_security_invoker('taptest', 'someview', ''),
    true,
    'has_security_invoker() with correct specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_invoker('taptest', 'definerview', ''),
    false,
    'has_security_invoker() with incorrect specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_invoker('taptest', 'nonexistent', ''),
    false,
    'has_security_invoker() with nonexistent view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_invoker('taptest', 'someview', ''),
    true,
    'has_security_invoker() default description',
    'View taptest.someview should have SECURITY INVOKER',
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_invoker('taptest', 'someview', 'desc'),
    true,
    'has_security_invoker() description supplied',
    'desc',
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_invoker('taptest', 'nonexistent', ''),
    false,
    'has_security_invoker() View not found diagnostic',
    null,
    'View taptest.nonexistent does not exist',
    0
);


/****************************************************************************/
-- has_security_definer(sname VARCHAR(64), vname VARCHAR(64), description TEXT)

SELECT tap.check_test(
    tap.has_security_definer('taptest', 'definerview', ''),
    true,
    'has_security_definer() with correct specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_definer('taptest', 'someview', ''),
    false,
    'has_security_definer() with incorrect specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_definer('taptest', 'nonexistent', ''),
    false,
    'has_security_definer() with nonexistent view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_definer('taptest', 'definerview', ''),
    true,
    'has_security_definer() default description',
    'View taptest.definerview should have SECURITY DEFINER',
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_definer('taptest', 'definerview', 'desc'),
    true,
    'has_security_definer() description supplied',
    'desc',
    null,
    0
);

SELECT tap.check_test(
    tap.has_security_definer('taptest', 'nonexistent', ''),
    false,
    'has_security_definer() View not found diagnostic',
    null,
    'View taptest.nonexistent does not exist',
    0
);


/****************************************************************************/
-- view_security_type_is(sname VARCHAR(64), vname VARCHAR(64), stype VARCHAR(7), description TEXT)

SELECT tap.check_test(
    tap.view_security_type_is('taptest', 'definerview', 'DEFINER', ''),
    true,
    'view_security_type_is() with correct specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_security_type_is('taptest', 'someview', 'INVOKER', ''),
    true,
    'view_security_type_is() with correct specification II',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_security_type_is('taptest', 'someview', 'DEFINER', ''),
    false,
    'view_security_type_is() with incorrect specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_security_type_is('taptest', 'definerview', 'INVOKER', ''),
    false,
    'view_security_type_is() with incorrect specification II',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_security_type_is('taptest', 'nonexistent', 'DEFINER', ''),
    false,
    'view_security_type_is() with nonexistent view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_security_type_is('taptest', 'definerview', 'DEFINER', ''),
    true,
    'view_security_type_is() default description',
    'View taptest.definerview should have Security Type \'DEFINER\'',
    null,
    0
);

SELECT tap.check_test(
    tap.view_security_type_is('taptest', 'definerview', 'DEFINER', 'desc'),
    true,
    'view_security_type_is() description supplied',
    'desc',
    null,
    0
);

SELECT tap.check_test(
    tap.view_security_type_is('taptest', 'nonexistent', 'DEFINER', ''),
    false,
    'view_security_type_is() View not found diagnostic',
    null,
    'View taptest.nonexistent does not exist',
    0
);


/****************************************************************************/
-- view_check_option_is(sname VARCHAR(64), vname VARCHAR(64), copt VARCHAR(8), description TEXT)

SELECT tap.check_test(
    tap.view_check_option_is('taptest', 'definerview', 'NONE', ''),
    true,
    'view_check_option_is() with correct specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_check_option_is('taptest', 'someview', 'LOCAL', ''),
    true,
    'view_check_option_is() with correct specification II',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_check_option_is('taptest', 'someview', 'NONE', ''),
    false,
    'view_check_option_is() with incorrect specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_check_option_is('taptest', 'definerview', 'CASCADED', ''),
    false,
    'view_check_option_is() with incorrect specification II',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_check_option_is('taptest', 'nonexistent', 'LOCAL', ''),
    false,
    'view_check_option_is() with nonexistent view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_check_option_is('taptest', 'someview', 'LOCAL', ''),
    true,
    'view_check_option_is() default description',
    'View taptest.someview should have Check Option \'LOCAL\'',
    null,
    0
);

SELECT tap.check_test(
    tap.view_check_option_is('taptest', 'someview', 'LOCAL', 'desc'),
    true,
    'view_check_option_is() description supplied',
    'desc',
    null,
    0
);

SELECT tap.check_test(
    tap.view_check_option_is('taptest', 'nonexistent', 'LOCAL', ''),
    false,
    'view_check_option_is() View not found diagnostic',
    null,
    'View taptest.nonexistent does not exist',
    0
);



/****************************************************************************/
-- view_is_updatable(sname VARCHAR(64), vname VARCHAR(64), updl VARCHAR(3), description TEXT)

SELECT tap.check_test(
    tap.view_is_updatable('taptest', 'definerview', 'YES', ''),
    true,
    'view_is_updatable() with correct specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_is_updatable('taptest', 'someview', 'NO', ''),
    false,
    'view_is_updatable() with incorrect specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_is_updatable('taptest', 'nonexistent', 'YES', ''),
    false,
    'view_is_updatable() with nonexistent view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_is_updatable('taptest', 'someview', 'YES', ''),
    true,
    'view_is_updatable() default description',
    'View taptest.someview should have IS UPDATABLE \'YES\'',
    null,
    0
);

SELECT tap.check_test(
    tap.view_is_updatable('taptest', 'someview', 'YES', 'desc'),
    true,
    'view_is_updatable() description supplied',
    'desc',
    null,
    0
);

SELECT tap.check_test(
    tap.view_is_updatable('taptest', 'nonexistent', 'YES', ''),
    false,
    'view_is_updatable() View not found diagnostic',
    null,
    'View taptest.nonexistent does not exist',
    0
);



/****************************************************************************/
-- view_definer_is(sname VARCHAR(64), vname VARCHAR(64), dfnr VARCHAR(93), description TEXT)

SELECT tap.check_test(
    tap.view_definer_is('taptest', 'someview', 'root@localhost', ''),
    true,
    'view_definer_is() with correct specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_definer_is('taptest', 'someview', 'nobody@nonexistent', ''),
    false,
    'view_definer_is() with incorrect specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_definer_is('taptest', 'nonexistent', 'root@localhost', ''),
    false,
    'view_definer_is() with nonexistent view',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.view_definer_is('taptest', 'someview', 'root@localhost', ''),
    true,
    'view_definer_is() default description',
    'View taptest.someview should have DEFINER \'root@localhost\'',
    null,
    0
);

SELECT tap.check_test(
    tap.view_definer_is('taptest', 'someview', 'root@localhost', 'desc'),
    true,
    'view_definer_is() description supplied',
    'desc',
    null,
    0
);

SELECT tap.check_test(
    tap.view_definer_is('taptest', 'nonexistent', 'DEFINER', ''),
    false,
    'view_definer_is() View not found diagnostic',
    null,
    'View taptest.nonexistent does not exist',
    0
);




/****************************************************************************/
-- views_are(sname VARCHAR(64), want TEXT, description TEXT)


SELECT tap.check_test(
    tap.views_are('taptest', '`someview`,`definerview`', ''),
    true,
    'views_are() correct specification',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.views_are('taptest', '`someview`,`nonexistent`', ''),
    false,
    'views_are() incorrect specification',
    null,
    null,
    0
);


-- Note the diagnostic test here is dependent on the space after the hash
-- and before the line feed and the number of spaces before
-- the view names, which must = 7
SELECT tap.check_test(
    tap.views_are('taptest', '`someview`,`nonexistent`', ''),
    false,
    'views_are() diagnostic',
    null,
    '# 
    Extra views:
       definerview
    Missing views:
       nonexistent',
    0
);

SELECT tap.check_test(
    tap.views_are('taptest', '`someview`,`definerview`', ''),
    true,
    'views_are() default description',
    'Schema taptest should have the correct Views',
    null,
    0
);

SELECT tap.check_test(
    tap.views_are('taptest',  '`someview`,`definerview`', 'desc'),
    true,
    'views_are() description supplied',
    'desc',
    null,
    0
);


/****************************************************************************/

-- Finish the tests and clean up.

call tap.finish();
DROP DATABASE IF EXISTS taptest;
ROLLBACK;
