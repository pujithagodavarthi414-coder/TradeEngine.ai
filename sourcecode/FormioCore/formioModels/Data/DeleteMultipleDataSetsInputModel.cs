using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class DeleteMultipleDataSetsInputModel
    {
        public List<Guid> GenericFormSubmittedIds { get; set; }
        public bool Archive { get; set; }
        public bool AllowAnonymous { get; set; }

    }
}
