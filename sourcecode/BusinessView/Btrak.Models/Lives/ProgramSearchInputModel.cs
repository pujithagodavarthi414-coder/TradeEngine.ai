using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class ProgramSearchInputModel : SearchCriteriaInputModelBase
    {
        public ProgramSearchInputModel() : base(InputTypeGuidConstants.ContractModelInputCommandTypeGuid)
        {
        }

        public bool? IsPagingRequired { get; set; }
        public Guid? ProgramId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? DataSourceId { get; set; }
        public string ImageUrl { get; set; }
        public string KPIType { get; set; }
        public string Location { get; set; }
        public bool IsVerified { get; set; }
    }
}
