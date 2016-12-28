using System;
using System.Collections.Generic;
using System.Linq;

class Solution
{
    struct Range
    {
        public UInt32 a, b;

        public Range(UInt32[] range)
        {
            a = range[0];
            b = range[1];
        }

        public Range(UInt32 _a, UInt32 _b)
        {
            a = _a;
            b = _b;
        }

        public bool contains(UInt32 x)
        {
            return x >= a && x <= b;
        }

        public UInt32[] bounds()
        {
            return new UInt32[] {
                a > UInt32.MinValue ? a - 1 : UInt32.MinValue,
                b < UInt32.MaxValue ? b + 1 : UInt32.MaxValue
            };
        }
    }

    static bool contains(IEnumerable<Range> ranges, UInt32 point)
    {
        return ranges.Any(x => x.contains(point));
    }

    static List<Range> union(IEnumerable<Range> ranges)
    {
        var res = new List<Range>();
        if (ranges.Count() == 0) return res;

        var sortedRanges = ranges.OrderBy(r => r.a);
        var curRange = sortedRanges.First();
        curRange = new Range(curRange.a, curRange.b);
        foreach (var range in sortedRanges.Skip(1))
        {
            if (range.a - 1 > curRange.b)
            {
                //  non-overlapping
                res.Add(curRange);
                curRange = new Range(range.a, range.b);
            }
            else
            {
                //  overlapping, merge
                curRange.b = Math.Max(curRange.b, range.b);
            }
        }
        res.Add(curRange);
        return res;
    }

    static UInt32 minNonBlackListed(IEnumerable<Range> blackList)
    {
        return blackList
            .SelectMany(x => x.bounds())
            .Where(x => !contains(blackList, x))
            .Min();
    }

    static UInt32 coverage(IEnumerable<Range> ranges)
    {
        return (UInt32)ranges.Sum(r => r.b - r.a + 1);
    }

    static UInt32 countNonBlackListed(IEnumerable<Range> blackList)
    {
        List<Range> merged = union(blackList);
        return UInt32.MaxValue - UInt32.MinValue - coverage(merged) + 1;
    }

    static void Main(string[] args)
    {
        String fname = args.Count() > 0 ? args[0] : "input.txt";
        string[] lines = System.IO.File.ReadAllLines(fname);

        var blackList = lines.Select(line =>
            new Range(line.Split('-').Select(UInt32.Parse).ToArray()));

        Console.WriteLine($"Minimum allowed: {minNonBlackListed(blackList)}");
        Console.WriteLine($"Total allowed: {countNonBlackListed(blackList)}");
    }
}
