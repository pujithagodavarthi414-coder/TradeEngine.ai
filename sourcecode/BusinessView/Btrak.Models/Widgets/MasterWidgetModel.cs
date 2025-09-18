using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
    public class MasterWidgetModel
    {
        public Guid Id { get; set; }

        public string WidgetName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", WidgetName = " + WidgetName);
            return stringBuilder.ToString();
        }
    }
}
