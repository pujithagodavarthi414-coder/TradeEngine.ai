using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class CreateOrUpdateQunatityInputModel
    {
        public Guid? Id { get; set; }
        public string UniqueId { get; set; }
        public decimal ContractQuantity { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid CompanyId {get;set;}
        public bool? IsArchived { get; set; }
    }
}
