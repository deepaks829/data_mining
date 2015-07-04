module DataMining
  # PageRank Algorithm to measure the importance of nodes in a graph
  class PageRank
    attr_reader :graph, :ranks
    # Measure importance of nodes
    #
    # Arguments:
    #   graph: (array of arrays, like:
    #     [[:p1, [:p2]], [:p2, [:p1, :p3]], [:p3, [:p2]]]
    #   damping_factor: (double between 0 and 1)
    def initialize(graph, damping_factor = 0.85)
      @graph      = graph.to_h
      # { :p1 => [:p2], :p2 => [:p1,:p3], :p3 => [:p2] }
      @outlinks   = Hash.new { |_, key| @graph[key].size }
      # { :p1 => 1, :p2 => 2, :p3 => 1 }
      @inlinks    = Hash.new { |_, key| inlinks(key) }
      # { :p1 => [:p2], :p2 => [:p1,:p3], :p3 => [:p2] }
      @ranks      = Hash.new(1.0 / @graph.size)
      # { :p1 => 1/3, :p2 => 1/3, ... }

      @damper     = damping_factor
      @iterations = 100
    end

    def rank!
      pagerank
    end

    private

    def inlinks(key)
      @graph.select { |_, v| v.include?(key) }.keys
    end

    def pagerank
      @iterations.times { @ranks = next_state }
    end

    def next_state
      @graph.each_with_object({}) do |(node, _), ranks|
        ranks[node] = term + @damper * sum_incoming_scores(@inlinks[node])
      end
    end

    def sum_incoming_scores(in_links)
      in_links.map { |id| @ranks[id] / @outlinks[id] }.inject(:+)
    end

    def term
      @term ||= ((1 - @damper) / @graph.size)
    end
  end
end
