using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.EntryForm
{
    public class EntryFormFieldSearchInputModel
    {
        public Guid? EntryFormId { get; set; }
        public string SearchText { get; set; }
    }
}
