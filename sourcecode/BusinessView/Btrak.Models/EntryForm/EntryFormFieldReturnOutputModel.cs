using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.EntryForm
{
   public  class EntryFormFieldReturnOutputModel
    {
        public Guid? EntryFormId { get; set; }
        public string DisplayName { get; set; }
        public string FieldName { get; set; }
        public bool? IsDisplay { get; set; }
        public string Unit { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public string FieldTypeName { get; set; }
        public Guid? FieldTypeId { get; set; }
        public Guid? grdiD { get; set; }
        public string Name { get; set; }
        public decimal? EnteredResult { get; set; }
        public string SelectedGrdNames { get; set; }
        public string SelectedGrdIds { get; set; }
    }
}
