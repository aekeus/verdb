# verdb

Database version control (PostgreSQL for now)

# purpose

verdb manages the execution of postgres DDL scripts. It expects to be executed
in a directory containing list of sub-directories, each of which corresponds
to a set of changes. The sub-directories must contain an 'up.sql' and a 'down.sql'
script. (although these filename may be changed)

The list, and order of the changes, must be maintained in a control file. This file
is an ordered list of sub-directories. The pointer will reference a single
sub-directory name contained in this file.

verdb maintains a pointer to the last batch (directory) of ddl scripts that
executed correctly.

# example

```
verdb init database postgres batches
verdb status
verdb up all
verdb show all
verdb extract stored_procedure schema.name
```

```
verdb gen trigger students --table=students --func=log_students
verdb gen table instructors --table=instructors
verdb gen index instructors-index --table=instructors --fields=name,location --schema=sch
```

# install

With [npm](https://npmjs.org) do:

```
sudo npm install verdb -g
```

# license

MIT
