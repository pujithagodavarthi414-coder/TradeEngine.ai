using BTrak.Common;
using System;
namespace Btrak.Models
{
    public class ProductSearchCriteriaInputModel :SearchCriteriaInputModelBase
    {
        public ProductSearchCriteriaInputModel() : base(InputTypeGuidConstants.ProductSearchCriteriaInputCommandTypeGuid)
        {
        }   
        public Guid? ProductId { get; set; } 
    }
}
