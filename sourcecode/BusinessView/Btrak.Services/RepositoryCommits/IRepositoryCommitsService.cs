using Btrak.Models;
using Btrak.Models.RepositoryCommits;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.RepositoryCommits
{
    public interface IRepositoryCommitsService
    {
        bool UpsertGitlabCommits(GitLabCommitInputModel gitLabCommitInputModel, List<ValidationMessage> validationMessages);

        bool UpsertBitBucketCommits(BitBucketCommitInputModel bitBucketCommitInputModel, List<ValidationMessage> validationMessages);

        List<RepositoryCommitsModel> SearchRepositoryCommits(RepositoryCommitsSearchModel repositoryCommitsSearch, LoggedInContext loggeedInContext, List<ValidationMessage> validationMessages);
    }
}
