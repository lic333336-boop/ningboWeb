package com.lchjy.controller;

import com.lchjy.entity.NingboCulture;
import com.lchjy.service.CultureService;
import com.lchjy.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/culture")
@Slf4j
public class CultureController {

    @Autowired
    private CultureService cultureService;

    @GetMapping("/list")
    public Result list(@RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        log.info("查询文化列表: keyword={}, page={}, limit={}", keyword, page, limit);
        return Result.success(cultureService.list(keyword, page, limit));
    }

    @GetMapping("/{id}")
    public Result getById(@PathVariable Integer id) {
        log.info("查询文化详情: id={}", id);
        return Result.success(cultureService.getById(id));
    }

    @PostMapping("/add")
    public Result add(@RequestBody NingboCulture culture) {
        log.info("新增文化: {}", culture);
        cultureService.add(culture);
        return Result.success();
    }

    @PostMapping("/update")
    public Result update(@RequestBody NingboCulture culture) {
        log.info("修改文化: {}", culture);
        cultureService.update(culture);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        log.info("删除文化: id={}", id);
        cultureService.delete(id);
        return Result.success();
    }
}
