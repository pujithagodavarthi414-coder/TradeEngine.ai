using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomApplication
{
    public class DeleteMultipleDataSetsInputModel
    {
        public List<Guid> GenericFormSubmittedIds { get; set; }
        public bool Archive { get; set; }
        public bool AllowAnonymous { get; set; }
    }
}
