using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.RepositoryCommits;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace Btrak.Services.RepositoryCommits
{
    public class RepositoryCommitsService : IRepositoryCommitsService
    {
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly RepositoryCommitsRepository _repositoryCommitsRepository = new RepositoryCommitsRepository();

        public RepositoryCommitsService()
        {
        }

        public bool UpsertGitlabCommits(GitLabCommitInputModel gitLabCommitInputModel, List<ValidationMessage> validationMessages)
        {
            var siteAddress = HttpContext.Current.Request.Url.Authority;
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "siteAddress", siteAddress, "RepositoryCommitsService"));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "gitLabCommitInputModel", gitLabCommitInputModel, "RepositoryCommitsService"));

                    foreach (var commit in gitLabCommitInputModel.Commits)
                    {
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "commit", commit, "RepositoryCommitsService"));

                        List<UserDbEntity> userDetailsList = new List<UserDbEntity>();
                        string commiterEmail = commit.Author.Email;
                        try
                        {
                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "commiterEmail", commiterEmail, "RepositoryCommitsService"));
                            userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(commiterEmail) : _userRepository.GetUserDetailsByNameAndSiteAddress(commiterEmail, siteAddress);
                        }
                        catch (Exception exception)
                        {
                            LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGitlabCommits", " RepositoryCommitsService", exception.Message), exception);
                        }

                        if (userDetailsList.Count > 0)
                        {
                            RepositoryCommitsInputModel repositoryCommitsInputModel = new RepositoryCommitsInputModel()
                            {
                                CommiterEmail = commiterEmail,
                                CommitMessage = commit.Message,
                                CommiterName = userDetailsList.Count > 0 ? userDetailsList.FirstOrDefault().FullName : null,
                                CommitReferenceUrl = commit.Url,
                                CompanyId = (userDetailsList.Count > 0) ? userDetailsList.FirstOrDefault()?.CompanyId : null,
                                CommitedByUserId = (userDetailsList.Count > 0) ? userDetailsList.FirstOrDefault()?.Id : null,
                                FiledAddedXml = commit.Added.Count > 0 ? Utilities.GetXmlFromObject(commit.Added) : null,
                                FilesModifiedXml = commit.Modified.Count > 0 ? Utilities.GetXmlFromObject(commit.Modified) : null,
                                FilesRemovedXml = commit.Removed.Count > 0 ? Utilities.GetXmlFromObject(commit.Removed) : null,
                                FromSource = "GitLab",
                                CommitedDateTime = null,
                                RepositoryName = gitLabCommitInputModel.Project.Name
                            };

                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "repositoryCommitsInputModel", repositoryCommitsInputModel, "RepositoryCommitsService"));

                            var referenceId = _repositoryCommitsRepository.UpsertReposityCommits(repositoryCommitsInputModel, validationMessages);
                        }
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGitlabCommits", " RepositoryCommitsService", exception.Message), exception);
                }
            });

            return true;
        }

        public bool UpsertBitBucketCommits(BitBucketCommitInputModel bitBucketCommitInputModel, List<ValidationMessage> validationMessages)
        {
            var siteAddress = HttpContext.Current.Request.Url.Authority;
            TaskWrapper.ExecuteFunctionInNewThread(() =>
            {
                try
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "siteAddress", siteAddress, "RepositoryCommitsService"));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "bitBucketCommitInputModel", bitBucketCommitInputModel, "RepositoryCommitsService"));

                    foreach (var change in bitBucketCommitInputModel.Push.Changes)
                    {
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "change", change, "RepositoryCommitsService"));

                        foreach (var commit in change.Commits)
                        {
                            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "commit", commit, "RepositoryCommitsService"));

                            List<UserDbEntity> userDetailsList = new List<UserDbEntity>();
                            string commiterEmail = commit.Author?.Raw?.Split('<')?.Last();
                            commiterEmail = commiterEmail.Split('>')?.FirstOrDefault()?.Trim();
                            try
                            {
                                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "commiterEmail", commiterEmail, "RepositoryCommitsService"));

                                userDetailsList = CanByPassUserCompanyValidation() ? _userRepository.GetUserDetailsByName(commiterEmail) : _userRepository.GetUserDetailsByNameAndSiteAddress(commiterEmail, siteAddress);
                            }
                            catch (Exception exception)
                            {
                                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBitBucketCommits", " RepositoryCommitsService", exception.Message), exception);
                            }

                            if (userDetailsList.Count > 0)
                            {
                                RepositoryCommitsInputModel repositoryCommitsInputModel = new RepositoryCommitsInputModel()
                                {
                                    CommiterEmail = commiterEmail,
                                    CommitMessage = commit.Message,
                                    CommiterName = userDetailsList.Count > 0 ? userDetailsList.FirstOrDefault().FullName : null,
                                    CommitReferenceUrl = change.Links.Html.Href,
                                    CompanyId = (userDetailsList.Count > 0) ? userDetailsList.FirstOrDefault()?.CompanyId : null,
                                    CommitedByUserId = (userDetailsList.Count > 0) ? userDetailsList.FirstOrDefault()?.Id : null,
                                    //FiledAddedXml = commit.Added.Count > 0 ? Utilities.GetXmlFromObject(commit.Added) : null,
                                    //FilesModifiedXml = commit.Modified.Count > 0 ? Utilities.GetXmlFromObject(commit.Modified) : null,
                                    //FilesRemovedXml = commit.Removed.Count > 0 ? Utilities.GetXmlFromObject(commit.Removed) : null,
                                    CommitedDateTime = commit.Date,
                                    FromSource = "BitBucket",
                                    RepositoryName = bitBucketCommitInputModel.Repository.Name
                                };
                                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGitlabCommits", "repositoryCommitsInputModel", repositoryCommitsInputModel, "RepositoryCommitsService"));

                                var referenceId = _repositoryCommitsRepository.UpsertReposityCommits(repositoryCommitsInputModel, validationMessages);
                            }

                        }
                    }
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGitlabCommits", " RepositoryCommitsService", exception.Message), exception);
                }
            });

            return true;
        }

        public List<RepositoryCommitsModel> SearchRepositoryCommits(RepositoryCommitsSearchModel repositoryCommitsSearch, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchRepositoryCommits", "RepositoryCommitsSearchModel", repositoryCommitsSearch, "RepositoryCommitsService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var commits = _repositoryCommitsRepository.SearchReposityCommits(repositoryCommitsSearch, loggedInContext, validationMessages);

            if (commits.Count > 0)
            {
                Parallel.ForEach(commits, (commit) =>
                 {
                     commit.FilesAdded = commit.FiledAddedXml != null ? Utilities.GetObjectFromXml<string>(commit.FiledAddedXml, "ArrayOfString").ToList() : new List<string>();
                     commit.FilesAddedCount = commit.FilesAdded.Count();
                     commit.FilesModified = commit.FilesModifiedXml != null ? Utilities.GetObjectFromXml<string>(commit.FilesModifiedXml, "ArrayOfString").ToList() : new List<string>();
                     commit.FilesModifiedCount = commit.FilesModified.Count();
                     commit.FilesRemoved = commit.FilesRemovedXml != null ? Utilities.GetObjectFromXml<string>(commit.FilesRemovedXml, "ArrayOfString").ToList() : new List<string>();
                     commit.FilesRemovedCount = commit.FilesRemoved.Count();
                 });
            }

            return commits;
        }

        private bool CanByPassUserCompanyValidation()
        {
            if (!ConfigurationManager.AppSettings.AllKeys.Contains("EnvironmentName"))
            {
                return true;
            }

            return ConfigurationManager.AppSettings["EnvironmentName"] != "Production";
        }
    }
}
