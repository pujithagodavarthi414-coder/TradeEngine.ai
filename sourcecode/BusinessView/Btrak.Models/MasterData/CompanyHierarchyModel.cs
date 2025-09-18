
using System;

namespace Btrak.Models.MasterData
{
    public class CompanyHierarchyModel
    {
        public Guid? EntityId { get; set; }
        public string EntityName { get; set; }
        public bool IsEntity { get; set; }
        public bool IsGroup { get; set; }
        public bool IsBranch { get; set; }
        public bool IsCountry { get; set; }
        public bool IsHeadOffice { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? ParentEntityId { get; set; }
        public Guid? ChildEntityId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? TimeZoneId { get; set; }
        public bool IsArchive { get; set; }
        public Guid? DefaultPayrollTemplateId { get; set; }
        public string Address { get; set; }
        public string Description { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string PostalCode { get; set; }
        public string State { get; set; }
        public Guid? OperationsPerformedBy { get; set; }
    }
}
