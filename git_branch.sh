#!/bin/sh -fx

if [ "x$USER" == "x" ]; then
  echo "git_branch: Environment variable USER not defined."

  exit 1  
fi

GIT="git@github.com:$USER/git_branch.git"

rm -rf git_branch

git clone "$GIT" || exit $?

if git branch | grep master > /dev/null 2>&1; then
  git checkout master
fi

git branch | grep -v '*' | while read i; do
  git branch -d "$i"
  git push origin ":$i"
done

( cd git_branch

  git init

  cat <<EOF > README
A successful Git branching model:

http://nvie.com/posts/a-successful-git-branching-model/
EOF

  cat <<EOF > Makefile
EOF

  git add README Makefile

  git commit -m 'First commit'

  git push -u origin master

  git checkout -b develop master

  cat <<EOF >> Makefile
all:

EOF

  git commit -m 'Added all target.' Makefile

  cat <<EOF >> Makefile
clean:
	\$(RM) *~

EOF

  git commit -m 'Added clean target.' Makefile

  cat <<EOF >> Makefile
distclean:

EOF

  git commit -m 'Added distclean target.' Makefile

  git push origin develop

  git checkout -b release-0.1 develop

  ed -s Makefile <<EOF
/^distclean:/s/$/ clean/
w
q
EOF

  git commit -m 'Modified distclean target dependency.' Makefile

  git push origin release-0.1

  git checkout master

  git merge --no-ff release-0.1

  git tag -a "0.1" -m "v0.1"

  git push origin master

  git checkout develop

  git merge --no-ff release-0.1

  ed -s Makefile <<EOF
1i
.SUFFIXES:
.SUFFIXES: .cc .o

.
/clean:/
i
.cc.o:
	\$(CXX) -c -o $@ $<

.
w
q
EOF

  git commit -m 'Added .SUFFIXES phony target and .c.o target.' Makefile

  git push origin develop

  git checkout -b release-0.2 develop

  git push origin release-0.2

  git checkout master

  git merge --no-ff release-0.2

  git tag -a "0.2" -m "v0.2"

  git push origin master
)
