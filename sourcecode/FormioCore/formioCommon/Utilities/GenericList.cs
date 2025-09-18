using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioCommon.Utilities
{
    [Serializable]
    public class GenericList<T>
    {
        public List<T> ListItems { get; set; } = new List<T>();
    }
}
