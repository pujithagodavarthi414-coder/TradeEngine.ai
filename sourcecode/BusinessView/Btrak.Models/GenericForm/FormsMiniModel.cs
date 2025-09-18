using System;
using System.Collections.Generic;

namespace Btrak.Models.GenericForm
{
    public class FormsMiniModel
    {
        public string FormName { get; set; }
        public string KeyName { get; set; }
        public string KeyType { get; set; }
        public string Jsons { get; set; }
        public Guid? Id { get; set; }
        public Guid? FormId { get; set; }
        public DateTime? CreatedAt { get; set; }
        public string Format { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public int? DecimalLimit { get; set; }
        public string Path { get; set; } 
    }
}
