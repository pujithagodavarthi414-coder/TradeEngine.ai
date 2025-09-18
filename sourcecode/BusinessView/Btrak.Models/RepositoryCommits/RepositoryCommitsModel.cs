using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.RepositoryCommits
{
    public class RepositoryCommitsModel
    {
        public string FromSource { get; set; }
        public string CommitMessage { get; set; }
        public string CommiterEmail { get; set; }
        public string CommiterName { get; set; }
        public List<string> FilesModified { get; set; }
        public List<string> FilesAdded { get; set; }
        public List<string> FilesRemoved { get; set; }
        public string FilesModifiedXml { get; set; }
        public string FiledAddedXml { get; set; }
        public string FilesRemovedXml { get; set; }
        public int FilesModifiedCount { get; set; }
        public int FilesAddedCount { get; set; }
        public int FilesRemovedCount { get; set; }
        public string RepositoryName { get; set; }
        public string CommitReferenceUrl { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CommiterUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int TotalCount { get; set; }
    }
}
