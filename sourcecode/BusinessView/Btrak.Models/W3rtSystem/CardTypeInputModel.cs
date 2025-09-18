using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.W3rtSystem
{
    public class CardTypeInputModel : SearchCriteriaInputModelBase
    {
        public CardTypeInputModel() : base(InputTypeGuidConstants.CardTypeInputCommandTypeGuid)
        {
        }

        public Guid? CardTypeId { get; set; }
        public string CardTypeName { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CardTypeId = " + CardTypeId);
            return stringBuilder.ToString();
        }
    }
}
