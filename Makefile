GIT_TAG=$(shell git describe --exact-match HEAD)
GIT_REPO=$(REPO_OWNER)/$(REPO_NAME)

.PHONY: check
check:
	./scripts/checker.sh --helm-lint --directories ./bundles --helm-version v2.10.0

.PHONY: convert
convert:
    ./scripts/convert.sh

.PHONY: generate-changelog
generate-changelog:
    ifneq($(strip $(GIT_TAG)),)
    ifneq($(strip $(GIT_TAG)),latest)
    ./scripts/generate_changelog.sh
    endif
    endif

.PHONY: latest-tag
latest-tag:
    ./scripts/create_latest_tag_step.sh https://$(GIT_TOKEN)@github.com/$(GIT_REPO)

.PHONY: release
release:
    ./scripts/create_release_branch_step.sh $(GIT_TAG) https://$(GIT_TOKEN)@github.com/$(GIT_REPO)

.PHONY: push-release
push-release:
    ./scripts/push_release.sh $(GIT_TAG) $(GIT_REPO)

.PHONY: ci-pr
ci-pr: check generate-changelog convert release push-release

.PHONY: ci-master
ci-master: check generate-changelog latest-tag convert release push-release

.PHONY: ci-release
ci-release: check generate-changelog convert release push-release
