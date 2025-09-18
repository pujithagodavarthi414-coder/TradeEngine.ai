using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.RepositoryCommits
{
    public class RepositoryCommitsSearchModel: SearchCriteriaInputModelBase
    {
        public RepositoryCommitsSearchModel() : base(InputTypeGuidConstants.RepositoryCommitsInputCommandTypeGuid)
        {
        }

        public Guid? UserId { get; set; }
        public DateTime? OnDate { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}
