# frozen_string_literal: true

# Cases tested:
#| code  a | code b | comment a | comment b |
#|:-------:|:------:|:---------:|:---------:|
#|   ''    |   -    |    -      |    -      |
#|   -     |   ''   |    -      |    -      |
#|   ''    |   B    |    -      |    -      |
#|   -     |   B    |    -      |    -      |
#|   A     |   B    |    -      |    -      |
#|   A     |   -    |    -      |    -      |
#|   A     |  ''    |    -      |    -      |
#|   A     |  '_'   |    -      |    -      |
#|   '_'   |   B    |    -      |    -      |
#|   A     |   A    |    -      |    D      |
#|   A     |   A    |    C      |    D      |
#|   A     |   A    |    C      |    -      |
#|   -     |   -    |    -      |    D      |
#|   -     |   -    |    C      |    D      |
#|   -     |   -    |    C      |    -      |
#|   A     |   B    |    C      |    C      |
#|   A     |   B    |    C      |    D      |
#|---------|--------|-----------|-----------|

# This is a test editing file
# The empty line below will be delete.
# This line meets the one above

# This line separates from the one above
# Code is appeded below
a = b + c
# Code is inserted below
s = 'abc'
# Code is edited below
q = r && s
# Code below is deleted
# Code below is cleared

# Code below is spaced
               

# Space below is written on
h = Hash.new               
# The side comment below is added
d2 = d * d # Distance Squared
# The side comment below is edited
two = 1 + 1 # 2 == 1 + 1
# The side comment below is deleted
three = two + 1
# Adding a comment below
# Comment added
# Comment added above
# This Comment Edited
# The comment below is deleted
# The comment above is deleted
# Code with side comment, code edited.
@a = 10 # Setting @a to 10
# Both code and comment are edited
easy = !peasy # Not so easy as 1, 2, 3
