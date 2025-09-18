using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.RepositoryCommits
{
    public class GitHubCommitInputModel
    {
        public string Ref { get; set; }
        public string Before { get; set; }
        public string After { get; set; }
        public bool Created { get; set; }
        public bool Deleted { get; set; }
        public bool Forced { get; set; }
        public string Base_ref { get; set; }
        public string Compare { get; set; }
        public List<GitCommitsModel> Commits { get; set; }
        public string Head_commit { get; set; }
        public GitRepositoryModel Repository { get; set; }
        public GitAuthorModel Pusher { get; set; }
        public GitSenderModel Sender { get; set; }
    }

    public class GitAuthorModel
    {
        public string Name { get; set; }
        public string Email { get; set; }
    }

    public class GitCommitsModel
    {
        public string Id { get; set; }
        public string Message { get; set; }
        public string Url { get; set; }
        public List<GitAuthorModel> Author { get; set; }
        public List<string> Added { get; set; }
        public List<string> Modified { get; set; }
        public List<string> Removed { get; set; }
    }

    public class GitRepositoryModel
    {
        public int Id { get; set; }
        public string Node_id { get; set; }
        public string Name { get; set; }
        public string Full_name { get; set; }
        public bool Private { get; set; }
        public GitOwnerModel Owner { get; set; }
        public string Html_url { get; set; }
        public string Description { get; set; }
        public bool Fork { get; set; }
        public string Url { get; set; }
        public string Forks_url { get; set; }
        public string Keys_url { get; set; }
        public string Collaborators_url { get; set; }
        public string Teams_url { get; set; }
        public string Hooks_url { get; set; }
        public string Issue_events_url { get; set; }
        public string Events_url { get; set; }
        public string Assignees_url { get; set; }
        public string Branches_url { get; set; }
        public string Tags_url { get; set; }
        public string Blobs_url { get; set; }
        public string Git_tags_url { get; set; }
        public string Git_refs_url { get; set; }
        public string Trees_url { get; set; }
        public string Statuses_url { get; set; }
        public string Languages_url { get; set; }
        public string Stargazers_url { get; set; }
        public string Contributors_url { get; set; }
        public string Subscribers_url { get; set; }
        public string Subscription_url { get; set; }
        public string Commits_url { get; set; }
        public string Git_commits_url { get; set; }
        public string Comments_url { get; set; }
        public string Issue_comment_url { get; set; }
        public string Contents_url { get; set; }
        public string Compare_url { get; set; }
        public string Merges_url { get; set; }
        public string Archive_url { get; set; }
        public string Downloads_url { get; set; }
        public string Issues_url { get; set; }
        public string Pulls_url { get; set; }
        public string Milestones_url { get; set; }
        public string Notifications_url { get; set; }
        public string Labels_url { get; set; }
        public string Releases_url { get; set; }
        public string Deployments_url { get; set; }
        public int Created_at { get; set; }
        public DateTime Updated_at { get; set; }
        public int Pushed_at { get; set; }
        public string Git_url { get; set; }
        public string Ssh_url { get; set; }
        public string Clone_url { get; set; }
        public string Svn_url { get; set; }
        public string Homepage { get; set; }
        public int Size { get; set; }
        public int Stargazers_count { get; set; }
        public int Watchers_count { get; set; }
        public string Language { get; set; }
        public bool Has_issues { get; set; }
        public bool Has_projects { get; set; }
        public bool Has_downloads { get; set; }
        public bool Has_wiki { get; set; }
        public bool Has_pages { get; set; }
        public int Forks_count { get; set; }
        public string Mirror_url { get; set; }
        public bool Archived { get; set; }
        public bool Disabled { get; set; }
        public int Open_issues_count { get; set; }
        public string License { get; set; }
        public int Forks { get; set; }
        public int Open_issues { get; set; }
        public int Watchers { get; set; }
        public string Default_branch { get; set; }
        public int Stargazers { get; set; }
        public string Master_branch { get; set; }
    }

    public class GitOwnerModel
    {
        public string Name { get; set; }
        public string Email { get; set; }
        public string Login { get; set; }
        public int Id { get; set; }
        public string Node_id { get; set; }
        public string Avatar_url { get; set; }
        public string Gravatar_id { get; set; }
        public string Url { get; set; }
        public string Html_url { get; set; }
        public string Followers_url { get; set; }
        public string Following_url { get; set; }
        public string Gists_url { get; set; }
        public string Starred_url { get; set; }
        public string Subscriptions_url { get; set; }
        public string Organizations_url { get; set; }
        public string Repos_url { get; set; }
        public string Events_url { get; set; }
        public string Received_events_url { get; set; }
        public string Type { get; set; }
        public bool Site_admin { get; set; }
    }

    public class GitSenderModel
    {
        public string Login { get; set; }
        public int Id { get; set; }
        public string Node_id { get; set; }
        public string Avatar_url { get; set; }
        public string Gravatar_id { get; set; }
        public string Url { get; set; }
        public string Html_url { get; set; }
        public string Followers_url { get; set; }
        public string Following_url { get; set; }
        public string Gists_url { get; set; }
        public string Starred_url { get; set; }
        public string Subscriptions_url { get; set; }
        public string Organizations_url { get; set; }
        public string Repos_url { get; set; }
        public string Events_url { get; set; }
        public string Received_events_url { get; set; }
        public string Type { get; set; }
        public bool Site_admin { get; set; }
    }
}
