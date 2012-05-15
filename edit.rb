class GapBuffer
  attr_accessor :gap_start, :gap_length

  GAP = " " * 64

  def initialize(data="", i=0)
    @data = data
    @gap_start = i
    @gap_length = 0
  end

  def to_s
    @data[0, gap_start] + @data[gap_end, @data.length-gap_end]
  end

  def insert_before(ch)
    maybe_create_new_gap
    @data[gap_start] = ch
    @gap_start += 1
    @gap_length -= 1
  end

  def insert_after(ch)
    maybe_create_new_gap
    @data[gap_end-1] = ch
    @gap_length -= 1
  end

  def delete_before
    return if gap_start.zero?
    @gap_start -= 1
    @gap_length += 1
  end

  def delete_after
    return if gap_end >= @data.length
    @gap_length += 1
  end

  def insert_string(s)
    s.each_char { |c| self.insert_before(c) }
  end

  def left
    return if gap_start.zero?
    @data[gap_end-1] = @data[gap_start-1]
    @gap_start -= 1
  end

  def right
    return if gap_end >= @data.length
    @data[gap_start] = @data[gap_end]
    @gap_start += 1
  end

  def up
    col = column
    cursor = gap_start - col
    return if cursor.zero?
    cursor_line = @data.rindex(?\n, cursor-2) || 0
    cursor_line += col + 1
    if cursor_line > cursor-1
      cursor_line = cursor-1
    end
    left while gap_start > cursor_line
  end

  def down
    col = column
    cursor = @data.index(?\n, gap_end)
    return if cursor.nil?
    cursor_line = cursor+1+col
    cursor = @data.index(?\n, cursor+1) || @data.length
    cursor_line = cursor if cursor_line > cursor
    right while gap_start + gap_length < cursor_line
  end

  private

  def gap_end
    gap_start+gap_length
  end

  def maybe_create_new_gap
    if gap_length.zero?
      @data[gap_start, 0] = GAP
      @gap_length = GAP.length
    end
  end

  # def position
  #   gap_start
  # end

  def column
    lbreak = @data.rindex(?\n, gap_start-1)
    lbreak.nil? ? gap_start : (gap_start-(lbreak+1))
  end

end
