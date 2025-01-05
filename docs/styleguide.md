# Don's Objective-C Styleguide

I start with Apple's Objective-C style but add some specific additions,
changes and embellishments below.  

## Values

I value both clarity and conciseness in my code, but I value clarity more.

## Formatting Guidelines

### Negation Operator Spacing

When using the negation `!` operator in an expression, add one space before
and after the `!` character.  This makes negation stand out when scanning code.

Example:

    // wrong: no space around `!`
    if (!object) {
        return NO;
    }
    
    // correct: `!` is very obvious
    if ( ! object) {
        return NO;
    }

### Method Definitions

When writing a method definition, add a semicolon at the end of the method
name and open the method body with a curly brace on the next line.  This makes
copying method declarations and pasting them to create or update method
definitions less fiddly, since no editing of the trailing semicolon is needed.

The opening curly brace of a method definition should be placed in the first
column of the next line. 

Example:

    // wrong: no semicolon, curly brace on same line
    - (BOOL)doSomeOperation {
        // statements
    }

    // correct: semicolon at end of method name and curly brace on next line
    - (BOOL)doSomeOperation;
    {
        // statements
    }

### Return Early

Prefer returning early from a function or method over nesting if/else blocks.
Deeply nested blocks are harder to read and make it harder to find matching
`else` clauses.

Example:

    // wrong: deep nesting is harder to read
    if (condition1) {
        if (condition2) {
            if (condition3) {
                // statements
            }
        } else {
            return ERROR2;
        }
    } else {  // wrong: 
        return ERROR1;
    }

    // correct: low / no nesting is easier to read
    if ( ! condition1) {
        return ERROR1;
    }
    if ( ! condition2) {
        return ERROR2;
    }
    if (condition3) {
        // statements
    }

### Init Method Boilerplate
 
When writing an init method, first initialize self by calling the super
initializer, then check self using `if ( ! self) return nil;`

    // wrong: nesting of initialization code
    - (instancetype)init;
    {
        self = [super init];
        if (self) {
            // initialize object
        }
        return self;
    }

    // correct: return early on init failure
    - (instancetype)init;
    {
        self = [super init];
        if ( ! self) return;
        
        // initialize object
        
        return self;
    }

### Spacing Between Method Declarations

In `@interface` blocks, add one blank line between method declarations.  In 
`@implementation` blocks, add two blank lines between method definitions.

### Method Grouping and Ordering

When generating classes, group methods in this order:

- class methods 
- initializers
- dealloc (if present)
- property methods
- data access methods 
- data mutation methods
- data deletion methods
- protocol and delegate methods

Within a group, sort methods in alphabetical order.
