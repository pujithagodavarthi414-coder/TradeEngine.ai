using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class MasterProduct :InputModelBase
    {
        public MasterProduct() : base(InputTypeGuidConstants.MasterProductCommandTypeGuid)
        {
        }

        public Guid? ProductId { get; set; }
        public string ProductName { get; set; }
        public bool IsArchived { get; set; }
        public string SearchText { get; set; }
    }
}
