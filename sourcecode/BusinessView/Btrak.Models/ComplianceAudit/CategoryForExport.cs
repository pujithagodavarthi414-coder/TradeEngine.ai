using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class CategoryForExport
    {
        public string CategoryName { get; set; }

        public string ParentCategoryName { get; set; }

        public string Description { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public List<QuestionsForExport> Questions { get; set; }

        public List<CategoryForExport> SubCategoriesForExport { get; set; }

        public Guid? CategoryId { get; set; }
    }
}
