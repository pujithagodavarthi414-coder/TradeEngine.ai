using System;
using System.Collections.Generic;

namespace BTrak.Common
{
    [Serializable]
    public class GenericList<T> 
    {
        public List<T> ListItems { get; set; } = new List<T>();
    }
}
