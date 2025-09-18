using System;
using System.Collections.Generic;

namespace Btrak.Models.RepositoryCommits
{
    public class GitLabCommitInputModel
    {
        public string Object_kind { get; set; }
        public string Before { get; set; }
        public string After { get; set; }
        public string Ref { get; set; }
        public string Checkout_sha { get; set; }
        public string User_id { get; set; }
        public string User_name { get; set; }
        public string User_username { get; set; }
        public string User_email { get; set; }
        public string User_avatar { get; set; }
        public string Project_id { get; set; }
        public GitLabProject Project { get; set; }
        public GitLabRepository Repository { get; set; }
        public List<GitLabCommit> Commits { get; set; }
        public int Total_commits_count { get; set; }
    }

    public class GitLabProject
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Web_url { get; set; }
        public object Avatar_url { get; set; }
        public string Git_ssh_url { get; set; }
        public string Git_http_url { get; set; }
        public string Namespace { get; set; }
        public int Visibility_level { get; set; }
        public string Path_with_namespace { get; set; }
        public string Default_branch { get; set; }
        public string Homepage { get; set; }
        public string Url { get; set; }
        public string Ssh_url { get; set; }
        public string Http_url { get; set; }
    }

    public class GitLabRepository
    {
        public string Name { get; set; }
        public string Url { get; set; }
        public string Description { get; set; }
        public string Homepage { get; set; }
        public string Git_http_url { get; set; }
        public string Git_ssh_url { get; set; }
        public int Visibility_level { get; set; }
    }

    public class GitLabCommit
    {
        public string Id { get; set; }
        public string Message { get; set; }
        public string Title { get; set; }
        public DateTime Timestamp { get; set; }
        public string Url { get; set; }
        public GitLabAuthor Author { get; set; }
        public List<string> Added { get; set; }
        public List<string> Modified { get; set; }
        public List<string> Removed { get; set; }
    }

    public class GitLabAuthor
    {
        public string Name { get; set; }
        public string Email { get; set; }
    }

    public class GitFilesListModel
    {
        public string GitFile { get; set; }
    }
}
