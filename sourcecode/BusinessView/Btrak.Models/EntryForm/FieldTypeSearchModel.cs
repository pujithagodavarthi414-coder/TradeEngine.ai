using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.EntryForm
{
    public class FieldTypeSearchModel
    {
        public Guid? Id { get; set; }
        public string FieldTypeName { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
