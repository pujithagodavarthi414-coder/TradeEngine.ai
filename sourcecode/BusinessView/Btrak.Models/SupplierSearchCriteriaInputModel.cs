using BTrak.Common;
using System;
namespace Btrak.Models
{
    public class SupplierSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public SupplierSearchCriteriaInputModel() : base(InputTypeGuidConstants.SupplierSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? SupplierId { get; set; }
    }
}
