using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels
{
    public class SearchCriteriaInputModelBase : InputModelBase
    {
        public SearchCriteriaInputModelBase(Guid inputCommandTypeGuid) : base(inputCommandTypeGuid)
        {
        }

        public int PageSize { get; set; } = 1000;
        public int PageNumber { get; set; } = 1;
        public string SearchText { get; set; }
        public string OrderByField { get; set; }
        public bool? OrderByDirection { get; set; }

        public Guid? CompanyId { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsFromExport { get; set; }
        public int Skip => (PageNumber == 1 || PageNumber == 0) ? 0 : PageSize * (PageNumber - 1);

        public string SortBy { get; set; }
        public bool SortDirectionAsc { get; set; }
        public string SortDirection => SortDirectionAsc ? "ASC" : "DESC";
    }
}
