all:
	./git_branch.sh

clean:
	$(RM) *~

distclean: clean
	$(RM) -r git_branch
