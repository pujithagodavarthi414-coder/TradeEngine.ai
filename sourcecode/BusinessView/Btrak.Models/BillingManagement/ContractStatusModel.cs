using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ContractStatusModel
    {
        public Guid? ContractStatusId { get; set; }
        public string ContractStatusName { get; set; }
        public string StatusName { get; set; }
        public string ContractStatusColor { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
    }

    public class RFQStatusModel
    {
        public Guid? RFQStatusId { get; set; }
        public string RFQStatusName { get; set; }
        public string StatusName { get; set; }
        public string RFQStatusColor { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
    }

    public class VesselConfirmationStatusModel
    {
        public Guid? StatusId { get; set; }
        public string VesselConfirmationStatusName { get; set; }
        public string StatusName { get; set; }
        public string StatusNameSearch { get; set; }
        public string StatusColor { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
