/*
TAP Tests for schema functions 
*/

BEGIN;

SELECT tap.plan(24);

-- setup for tests
DROP DATABASE IF EXISTS taptest;
CREATE DATABASE taptest COLLATE latin1_general_ci;


/****************************************************************************/
-- has_charset(cname VARCHAR(32), description TEXT)


SELECT tap.check_test(
    tap.has_charset('latin1', ''),
    true,
    'has_charset() extant charset',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_charset('nonexistent', ''),
    false,
    'has_charset() nonexistent charset',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_charset('latin1', ''),
    true,
    'has_charset() default description',
    'Character set latin1 should be available',
    null,
    0
);

SELECT tap.check_test(
    tap.has_charset('latin1', 'desc'),
    true,
    'has_charset() description supplied',
    'desc',
    null,
    0
);




/****************************************************************************/
-- hasnt_charset(sname VARCHAR(64), description TEXT)

SELECT tap.check_test(
    tap.hasnt_charset('nonexistent', ''),
    true,
    'hasnt_charset() with nonexistent charset',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_charset('latin1', ''),
    false,
    'hasnt_charset() with exitant charset',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_charset('nonexistent', ''),
    true,
    'hasnt_charset() default description',
    'Character Set nonexistent should not be available',
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_charset('nonexistent', 'desc'),
    true,
    'hasnt_charset() description supplied',
    'desc',
    null,
    0
);




/****************************************************************************/
-- tests on synonyms
-- has_character_set(cname VARCHAR(32), description TEXT)
SELECT tap.check_test(
    tap.has_character_set('latin1', ''),
    true,
    'has_character_set() extant character set',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_character_set('nonexistent', ''),
    false,
    'has_character_set() nonexistent character set',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.has_character_set('latin1', ''),
    true,
    'has_character_set() default description',
    'Character set latin1 should be available',
    null,
    0
);

SELECT tap.check_test(
    tap.has_character_set('latin1', 'desc'),
    true,
    'has_character_set() description supplied',
    'desc',
    null,
    0
);



/****************************************************************************/
-- hasnt_character_set(cname VARCHAR(32), description TEXT)
SELECT tap.check_test(
    tap.hasnt_character_set('nonexistent', ''),
    true,
    'hasnt_character_set() with nonexistent character set',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_character_set('latin1', ''),
    false,
    'hasnt_character_set() with exitant character set',
    null,
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_character_set('nonexistent', ''),
    true,
    'hasnt_character_set() default description',
    'Character Set nonexistent should not be available',
    null,
    0
);

SELECT tap.check_test(
    tap.hasnt_character_set('nonexistent', 'desc'),
    true,
    'hasnt_character_set() description supplied',
    'desc',
    null,
    0
);



/****************************************************************************/

-- Finish the tests and clean up.

call tap.finish();
DROP DATABASE IF EXISTS taptest;
ROLLBACK;
