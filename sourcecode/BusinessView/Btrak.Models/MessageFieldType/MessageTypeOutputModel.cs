using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MessageFieldType
{
    public class MessageFieldTypeOutputModel
    {
        public Guid? MessageId { get; set; }
        public string DisplayText { get; set; }
        public string MessageType { get; set; }
        public bool? IsDisplay { get; set; }
        public bool? IsSendInMail { get; set; }
        public string SelectedGrdNames { get; set; }
        public string SelectedGrdIds { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? GrdId { get; set; }
    }
}
