require "ast/ast_scope.rb"
require "ast/ast_stat.rb"
require "ast/ast_expr.rb"
require "ruby-graphviz"

module PassModule

  class BasicBlock
    attr_reader :label
    attr_reader :stmts
    attr_accessor :out
    attr_accessor :out_blocks
    def initialize s
      @label = s
      @stmts = []
      @out = nil
      @out_blocks = []
    end
    def add_stmt chld
      stmts << chld
    end
    def <<(chld)
      add_stmt chld
    end
    def to_s
      stmts.map(&:c_dump).join("")
    end
  end

  class Function
    attr_reader :labels, :entry_bb, :exit_bbs, :val

    def basic_blocks
      labels.values
    end

    #give each bb a label
    def start_bb stmt
      #split up bb if jumps into code
      if @cur_bb != nil
        fin_bb stmt
      end
      @cur_bb = BasicBlock.new stmt
      @labels[stmt.label] = @cur_bb
    end 

    #end on a return, goto, or additional label
    def fin_bb stmt
      @cur_bb.out = stmt
      @last_bb = @cur_bb
      @cur_bb = nil
    end

    def process_stmt stmt
      case stmt.class.name
      when "Ast::GotoStat", "Ast::ReturnStat"
        fin_bb stmt
      when "Ast::AssignStat"
        @cur_bb << stmt
      when "Ast::LabelStat"
        start_bb stmt
      end
    end

    def link_bbs
      basic_blocks.each do |bb|
        out_stmt = bb.out
        case out_stmt.class.name
        when "Ast::GotoStat"
          if out_stmt.is_cond?
            bb.out_blocks = bb.out_blocks << @labels[bb.out.target_true]
            bb.out_blocks = bb.out_blocks <<  @labels[bb.out.target_false]
          else
            bb.out_blocks = bb.out_blocks <<  @labels[bb.out.target]
          end
        when "Ast::ReturnStat"
          @exit_bbs << bb
        end
      end
      @entry_bb = @labels["lbl_entry"]
    end
    
    def initialize func_node
      @labels = Hash.new
      @cur_bb = nil
      @val = func_node
      @exit_bbs = []
      func_node.each do |stmt|
        process_stmt stmt
      end
      link_bbs
    end 
  end

  leaders = []
  Pass = Proc.new do |prog|
    index = 0;
    next_leader = true
    in_block = false
    funcs = prog.children_copy.map do |chld|
      Function.new chld
    end
    g = GraphViz.new(:G, :type => :digraph)
    funcs.each do |func|
      graph_nodes = []
      graph_index_hash = Hash.new
      func.basic_blocks.each_with_index do |bb, index| 
        graph_nodes << g.add_nodes(func.val.id + ":\n" + bb.to_s)
        graph_index_hash[bb.label.label] = index
      end
      func.basic_blocks.each do |bb|
        bb.out_blocks.each do |out|
          g1 = graph_nodes[graph_index_hash[bb.label.label]]
          g2 = graph_nodes[graph_index_hash[out.label.label]]
          g.add_edges(g1, g2)
        end
      end
    end
    g.output( :png => "cfg.png")
  end
end
