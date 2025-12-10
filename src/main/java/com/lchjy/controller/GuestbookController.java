package com.lchjy.controller;

import com.lchjy.entity.Guestbook;
import com.lchjy.service.GuestbookService;
import com.lchjy.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/guestbook")
@Slf4j
public class GuestbookController {

    @Autowired
    private GuestbookService guestbookService;

    @GetMapping("/list")
    public Result list(@RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        log.info("查询留言板列表: page={}, limit={}", page, limit);
        return Result.success(guestbookService.list(page, limit));
    }

    @PostMapping("/add")
    public Result add(@RequestBody Guestbook guestbook) {
        log.info("新增留言: {}", guestbook);
        guestbookService.add(guestbook);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    public Result delete(@PathVariable Integer id) {
        log.info("删除留言: id={}", id);
        guestbookService.delete(id);
        return Result.success();
    }
}
