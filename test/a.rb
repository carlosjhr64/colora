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

# Code is inserted below
# Code is edited below
q = r || s
# Code below is deleted
exit(1)
# Code below is cleared
raise 'cleared'
# Code below is spaced
def wut = 'wut'

# Space below is written on
               
# The side comment below is added
d2 = d * d
# The side comment below is edited
two = 1 + 1 # 2==1+1
# The side comment below is deleted
three = two + 1 # Duh!
# Adding a comment below
# Comment added above
# This comment edited
# The comment below is deleted
# This comment will be deleted
# The comment above is deleted
# Code with side comment, code edited.
self.a = 10 # Setting @a to 10
# Both code and comment are edited
easy = peasy # Easy as 1, 2, 3
