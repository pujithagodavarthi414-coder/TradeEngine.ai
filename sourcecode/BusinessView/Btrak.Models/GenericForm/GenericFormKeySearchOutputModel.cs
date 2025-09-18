using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class GenericFormKeySearchOutputModel
    {
        public Guid?  GenericFormId { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public string Key { get; set; }
        public bool? IsDefault { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public bool? IsArchived { get; set; }
        public string Label { get; set; }
        public int? DecimalLimit { get; set; }
        public string Type { get; set; }
        public string Format { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
    }
}