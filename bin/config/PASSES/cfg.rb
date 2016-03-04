require "ast/ast_scope.rb"
require "ast/ast_stat.rb"
require "ast/ast_expr.rb"

module PassModule

  class BasicBlock
    attr_reader :label
    attr_reader :stmts
    attr_accessor :out_stmt
    attr_accessor :out_blocks
    def initialize s
      @label = nil
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
  end

  class Function
    attr_reader :labels, :entry_bb

    def basic_blocks
      labels.values
    end

    #give each bb a label
    def start_bb stmt
      #split up bb if jumps into code
      if cur_bb != nil
        fin_bb stmt
      end
      @cur_bb = BasicBlock.new stmt
      @labels[stmt] = @cur_bb
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
    
    def initalize func_node
      @labels = Hash.new
      @cur_bb = nil
      func_node.each do |stmt|
        process_stmt stmt
      end
      basic_blocks.each do |bb|
        out_stmt = bb.out
        case out_stmt.class.name
        when "Ast::GotoStat"
          if out_stmt.cond?

          else

          end

        end
        bb.out_blocks << 
      end
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
  end
end
