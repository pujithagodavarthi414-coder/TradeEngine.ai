using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class SearchEntityApiOutputModel
    {  
        public Guid EntityId { get; set; }
        public string EntityName { get; set; }
        public  bool IsBranch { get; set; }
        public bool IsGroup { get; set; }
        public bool IsCountry { get; set; }
        public bool IsEntity { get; set; }
        public string Description { get; set; }
        public Guid? ParentEntityId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsHeadOffice { get; set; }
        public string Address { get; set; }
        public string TimeZoneName { get; set; }
        public string CurrencyName { get; set; }
        public string PayrollName { get; set; }
        public string CurrencyCode { get; set; }
        public string PayrollShortName { get; set; }
        public Guid? TimeZoneId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? PayrollTemplateId { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string PostalCode { get; set; }
        public Guid CountryId { get; set; }
        public string CountryName { get; set; }
        public string State { get; set; }
        public Guid? DefaultPayrollTemplateId { get; set; }
        public List<SearchEntityApiOutputModel> Children { get; set; }
    }
}
