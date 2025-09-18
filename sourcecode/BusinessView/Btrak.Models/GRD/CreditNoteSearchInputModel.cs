using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class CreditNoteSearchInputModel : SearchCriteriaInputModelBase
    {
        public CreditNoteSearchInputModel() : base(InputTypeGuidConstants.CreditNoteSearchInputModelCommandTypeGuid)
        {
        }
        public Guid? CreditNoteId { get; set; }
    }
}
