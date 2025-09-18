using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomFields
{
    public class CustomFieldSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public CustomFieldSearchCriteriaInputModel() : base(InputTypeGuidConstants.CustomFieldSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? ReferenceId { get; set; }
        public Guid? CustomFieldId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public int? ModuleTypeId { get; set; }
        public string FormName { get; set; }
    }
}
