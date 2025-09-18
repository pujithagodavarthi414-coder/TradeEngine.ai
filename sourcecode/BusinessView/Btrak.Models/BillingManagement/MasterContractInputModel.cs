using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class MasterContractInputModel
    {
        public Guid? ProductId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? ContractId { get; set; }
        public string ContractName { get; set; }
        public string ContractNumber { get; set; }
        public string ContractUniqueName { get; set; }
        public string SearchText { get; set; }
        public string Description { get; set; }
        public Guid? GradeId { get; set; }
        public decimal RateOrTon { get; set; }
        public int ContractQuantity { get; set; }
        public int RemaningQuantity { get; set; }
        public int UsedQuantity { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime? ContractDateFrom { get; set; }
        public DateTime? ContractDateTo { get; set; }
        public string ContractDocument { get; set; }
        public bool IsArchived { get; set; }
        public int PageSize { get; set; } = 1000;
        public int PageNumber { get; set; } = 1;
        public string SortBy { get; set; }
        public bool SortDirectionAsc { get; set; }
        public string SortDirection => SortDirectionAsc ? "ASC" : "DESC";

    }
}
