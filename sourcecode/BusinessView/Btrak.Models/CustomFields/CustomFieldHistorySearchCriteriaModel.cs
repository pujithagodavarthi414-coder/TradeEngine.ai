using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomFields
{
   public  class CustomFieldHistorySearchCriteriaModel : SearchCriteriaInputModelBase 
    {
        public CustomFieldHistorySearchCriteriaModel() : base(InputTypeGuidConstants.CustomFieldSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? CustomFieldId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
    }
}
