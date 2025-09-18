using System;

namespace Btrak.Models.GenericForm
{
    public class GetCustomeApplicationTagOutputModel
    {
        public Guid? CustomApplicationTagId { get; set; } 
        public string TagValue { get; set; }
        public string CustomApplicationName { get; set; }
        public string FormName { get; set; }
        public string Key { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public string GenericFormLabel { get; set; }
    }
}
