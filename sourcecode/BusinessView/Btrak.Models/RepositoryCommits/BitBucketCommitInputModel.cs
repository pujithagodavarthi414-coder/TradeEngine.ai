using System;
using System.Collections.Generic;

namespace Btrak.Models.RepositoryCommits
{
    public class BitBucketCommitInputModel
    {
        public BitBucketPush Push { get; set; }
        public BitBucketActor Actor { get; set; }
        public BitBuckerRepository Repository { get; set; }
    }

    public class BitBuckerRepository
    {
        public string Scm { get; set; }
        public string Website { get; set; }
        public string Uuid { get; set; }
        public object Links { get; set; }
        public object Project { get; set; }
        public string Full_name { get; set; }
        public object Owner { get; set; }
        public object Workspace { get; set; }
        public string Type { get; set; }
        public bool? Is_private { get; set; }
        public string Name { get; set; }
    }

    public class BitBucketPush
    {
        public List<BitBucketChange> Changes { get; set; }
    }

    public class BitBucketChange
    {
        public bool? Forced { get; set; }
        public BitBucketDetailsModel Old { get; set; }
        public BitBucketLinksModel Links { get; set; }
        public bool? Created { get; set; }
        public List<BitBucketTarget> Commits { get; set; }
        public bool? Truncated { get; set; }
        public bool? Closed { get; set; }
        public BitBucketDetailsModel New { get; set; }
    }

    public class BitBucketDetailsModel
    {
        public string Name { get; set; }
        public BitBucketLinksModel Links { get; set; }
        public string Default_merge_strategy { get; set; }
        public List<string> Merge_strategies { get; set; }
        public string Type { get; set; }
        public BitBucketTarget Target { get; set; }
    }

    public class BitBucketLinksModel
    {
        public BitBucketHrefModel Self { get; set; }
        public BitBucketHrefModel Comments { get; set; }
        public BitBucketHrefModel Patch { get; set; }
        public BitBucketHrefModel Html { get; set; }
        public BitBucketHrefModel Diff { get; set; }
        public BitBucketHrefModel Approve { get; set; }
        public BitBucketHrefModel Statuses { get; set; }
        public BitBucketHrefModel Avatar { get; set; }
    }

    public class BitBucketTarget
    {
        public Object Rendered { get; set; }
        public string Hash { get; set; }
        public BitBucketLinksModel Links { get; set; }
        public BitBucketAuthor Author { get; set; }
        public BitBucketSummaryModel Summary { get; set; }
        public List<BitBucketParent> Parents { get; set; }
        public DateTime? Date { get; set; }
        public string Message { get; set; }
        public string Type { get; set; }
        public object Properties { get; set; }
    }

    public class BitBucketActor
    {
        public string Display_name { get; set; }
        public string Account_id { get; set; }
        public BitBucketLinksModel Links { get; set; }
        public string Nickname { get; set; }
        public string Type { get; set; }
        public string Uuid { get; set; }
        public string Slug { get; set; }
    }

    public class BitBucketHrefModel
    {
        public string Href { get; set; }
    }
    
    public class BitBucketAuthor
    {
        public string Raw { get; set; }
        public string Type { get; set; }
    }

    public class BitBucketSummaryModel
    {
        public string Raw { get; set; }
        public string Markup { get; set; }
        public string Html { get; set; }
        public string Type { get; set; }
    }


    public class BitBucketParent
    {
        public string Hash { get; set; }
        public string Type { get; set; }
        public BitBucketLinksModel Links { get; set; }
    }
    
    // --------------------- old model --------------------------
    //public class BitBucketCommitInputModel
    //{
    //    public string Actor { get; set; }
    //    public string Repository { get; set; }
    //    public BitBucketPush Push { get; set; }
    //}

    //public class BitBucketPush
    //{
    //    public List<BitBucketChange> Changes { get; set; }
    //}

    //public class BitBucketChange
    //{
    //    public BitBucketNew New { get; set; }
    //    public BitBucketNew Old { get; set; }
    //    public BitBucketLinks Links { get; set; }
    //    public bool Created { get; set; }
    //    public bool Forced { get; set; }
    //    public bool Closed { get; set; }
    //    public List<BitBucketCommit> Commits { get; set; }
    //    public bool Truncated { get; set; }
    //}

    //public class BitBucketNew
    //{
    //    public string Type { get; set; }
    //    public string Name { get; set; }
    //    public BitBucketTarget Target { get; set; }
    //    public BitBucketLinks Links { get; set; }
    //}

    //public class BitBucketTarget
    //{
    //    public string Type { get; set; }
    //    public string Hash { get; set; }
    //    public string Author { get; set; }
    //    public string Message { get; set; }
    //    public DateTime Date { get; set; }
    //    public List<BitBucketParent> Parents { get; set; }
    //    public BitBucketLinks Links { get; set; }
    //}

    //public class BitBucketParent
    //{
    //    public string Type { get; set; }
    //    public string Hash { get; set; }
    //    public BitBucketLinks Links { get; set; }
    //}

    //public class BitBucketLinks
    //{
    //    public BitBucketSelf Self { get; set; }
    //    public BitBucketSelf Html { get; set; }
    //    public BitBucketSelf Commits { get; set; }
    //    public BitBucketSelf Diff { get; set; }
    //}

    //public class BitBucketSelf
    //{
    //    public string Href { get; set; }
    //}

    //public class BitBucketCommit
    //{
    //    public string Hash { get; set; }
    //    public string Type { get; set; }
    //    public string Message { get; set; }
    //    public string Author { get; set; }
    //    public BitBucketLinks Links { get; set; }
    //}
}
