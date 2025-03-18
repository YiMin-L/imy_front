<template>
  <span class="u-time">{{ displayTime }}</span>
</template>

<script>
export default {
  name: 'UTime',
  props: {
    value: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      displayTime: '',
      timer: null
    }
  },
  watch: {
    value: {
      immediate: true,
      handler() {
        this.updateTime()
      }
    }
  },
  mounted() {
    this.startTimer()
  },
  beforeDestroy() {
    this.clearTimer()
  },
  methods: {
    // 将时间字符串转换为 Date 对象（处理兼容性）
    parseTime(timeString) {
      // 将 "2023-10-05 14:30:45" 转换为 "2023/10/05 14:30:45"
      timeString = timeString.replace(/\//g, '-');

      return new Date(timeString)
    },

    // 计算相对时间
    beautifyTime(timeString) {
      const now = new Date()
      const targetTime = this.parseTime(timeString)
      const diff = now - targetTime

      const minute = 60 * 1000
      const hour = 60 * minute
      const day = 24 * hour

      if (diff < minute) {
        return '刚刚'
      } else if (diff < hour) {
        return `${Math.floor(diff / minute)}分钟前`
      } else if (diff < day) {
        return `${Math.floor(diff / hour)}小时前`
      } else if (diff < 30 * day) {
        return `${Math.floor(diff / day)}天前`
      } else {
        // 超过30天显示具体日期
        return targetTime.toLocaleDateString()
      }
    },

    // 更新时间显示
    updateTime() {
      this.displayTime = this.beautifyTime(this.value)
    },

    // 启动定时器（仅在需要时）
    startTimer() {
      this.clearTimer()

      const targetTime = this.parseTime(this.value)
      const diff = new Date() - targetTime

      // 仅在时间差小于35分钟时启动定时器
      if (diff < 35 * 60 * 1000) {
        this.timer = setInterval(() => {
          this.updateTime()
        }, 60 * 1000) // 每分钟更新一次
      }
    },

    // 清除定时器
    clearTimer() {
      if (this.timer) {
        clearInterval(this.timer)
        this.timer = null
      }
    }
  }
}
</script>

<style scoped>
.u-time {
  color: #666;
  font-size: 12px;
}
</style>