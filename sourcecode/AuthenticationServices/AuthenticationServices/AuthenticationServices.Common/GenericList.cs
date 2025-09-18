using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Common
{
    [Serializable]
    public class GenericList<T>
    {
        public List<T> ListItems { get; set; } = new List<T>();
    }
}
