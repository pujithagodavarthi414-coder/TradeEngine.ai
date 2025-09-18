using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MessageFieldType
{
    public class MessageFieldSearchInputModel
    {
        public Guid? MessageId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }
    }
}
